import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

import 'special_education_data.dart';

class SpecialEducationViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<SpecialEducationData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  SpecialEducationViewModel(
    BuildContext ctx, {
    @required Repository repository,
    @required RemoteConfig remoteConfig,
    @required GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings,
        super(ctx);

  List<SpecialEducation> _specialEducation;
  List<Filter> _filters;
  Lookups _lookups;

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _dataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _loadNote();
    _loadData();
  }

  void _loadNote() {
    launchHandled(() async {
      final note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.specialEducation)
          ?.note;
      _pageNoteSubject.add(note);
    }, notifyProgress: true);
  }

  void _loadData() {
    handleRepositoryFetch(fetch: () => _repository.fetchAllSpecialEducation())
        .doOnListen(() => notifyHaveProgress(true))
        .doOnDone(() => notifyHaveProgress(false))
        .listen(
          _onDataLoaded,
          onError: handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onDataLoaded(List<SpecialEducation> specialEducations) {
    launchHandled(() async {
      _lookups = await _repository.lookups.first;
      _specialEducation = specialEducations;
      _filters = await _initFilters();
      _filtersSubject.add(_filters);
      await _updatePageData();
    });
  }

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_SpecialEducationModel, SpecialEducationData>(
        _specialEducationModel,
        _SpecialEducationModel(
          _specialEducation,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_specialEducation == null || _lookups == null) {
      return [];
    }
    return _specialEducation.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<SpecialEducationData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _SpecialEducationModel {
  final List<SpecialEducation> specialEducation;
  final Lookups lookups;
  final List<Filter> filters;

  const _SpecialEducationModel(
      this.specialEducation, this.lookups, this.filters);
}

Future<SpecialEducationData> _specialEducationModel(
  _SpecialEducationModel _specialEducationModel,
) async {
  Map<String, Map<String, List<DataByGroup>>> dataByState = new Map();
  Map<String, Map<String, List<DataByGroup>>> dataByYear = new Map();

  final specialEducationData = _specialEducationModel.specialEducation;
  final filteredData =
      await specialEducationData.applyFilters(_specialEducationModel.filters);
  var dataByGender =
      _generateDataByTitle(filteredData.groupBy((it) => it.disability));
  var dataByEthnicity =
      _generateDataByTitle(filteredData.groupBy((it) => it.ethnicityCode));
  var dataBySpecialEdEnvironment =
      _generateDataByTitle(filteredData.groupBy((it) => it.environment));
  var dataByEnglishLearner =
      _generateDataByTitle(filteredData.groupBy((it) => it.englishLearner));

  dataByState['environment'] =
      _generateDataByYear(specialEducationData.groupBy((it) => it.environment));
  dataByState['disability'] =
      _generateDataByYear(specialEducationData.groupBy((it) => it.disability));
  dataByState['ethnicity'] = _generateDataByYear(
      specialEducationData.groupBy((it) => it.ethnicityCode));
  dataByState['englishLearner'] = _generateDataByYear(
      specialEducationData.groupBy((it) => it.englishLearner));

  dataByYear['environment'] = _generateDataByState(
      specialEducationData.groupBy((it) => it.environment));
  dataByYear['disability'] =
      _generateDataByState(specialEducationData.groupBy((it) => it.disability));
  dataByYear['ethnicity'] = _generateDataByState(
      specialEducationData.groupBy((it) => it.ethnicityCode));
  dataByYear['englishLearner'] = _generateDataByState(
      specialEducationData.groupBy((it) => it.englishLearner));

  return SpecialEducationData(
      dataByGender: dataByGender,
      dataByEthnicity: dataByEthnicity,
      dataBySpecialEdEnvironment: dataBySpecialEdEnvironment,
      dataByEnglishLearner: dataByEnglishLearner,
      dataByCohortDistributionByState: dataByState,
      dataByCohortDistributionByYear: dataByYear);
}

List<DataByGroup> _generateDataByTitle(
    Map<String, List<SpecialEducation>> dataGroupedByDisability) {
  List<DataByGroup> dataByGender = new List<DataByGroup>();
  dataGroupedByDisability.forEach((disability, values) {
    var male = 0;
    var female = 0;

    for (var data in values) {
      male += data.gender == 'Male' ? 0 : 1;
      female += data.gender == 'Female' ? 0 : 1;
    }
    dataByGender.add(DataByGroup(
        title: disability == "" ? 'na' : disability,
        firstValue: male,
        secondValue: female));
  });
  return dataByGender;
}

Map<String, List<DataByGroup>> _generateDataByYear(
    Map<String, List<SpecialEducation>> dataGroupedByEnvironment) {
  Map<String, List<DataByGroup>> dataByYearEnvironment =
      Map<String, List<DataByGroup>>();

  dataGroupedByEnvironment.forEach((environment, values) {
    Map<int, List<SpecialEducation>> groupedByYear =
        values.groupBy((it) => it.surveyYear);
    List<DataByGroup> dataByEnvironment = [];
    groupedByYear.forEach((key, value) {
      int number = 0;
      value.forEach((element) {
        number += element.number;
      });
      dataByEnvironment.add(DataByGroup(
          title: key.toString(), firstValue: number, secondValue: 0));
    });
    dataByYearEnvironment[environment] = dataByEnvironment ?? [];
  });
  return dataByYearEnvironment;
}

Map<String, List<DataByGroup>> _generateDataByState(
    Map<String, List<SpecialEducation>> dataGroupedByEnvironment) {
  Map<String, List<DataByGroup>> dataByYearEnvironment =
      Map<String, List<DataByGroup>>();

  dataGroupedByEnvironment.forEach((environment, values) {
    Map<String, List<SpecialEducation>> groupedByYear =
        values.groupBy((it) => it.districtCode);
    List<DataByGroup> dataByEnvironment = [];
    groupedByYear.forEach((key, value) {
      int number = 0;
      value.forEach((element) {
        number += element.number;
      });
      dataByEnvironment.add(DataByGroup(
          title: key.toString(), firstValue: number, secondValue: 0));
    });
    dataByYearEnvironment[environment] = dataByEnvironment ?? [];
  });
  return dataByYearEnvironment;
}
