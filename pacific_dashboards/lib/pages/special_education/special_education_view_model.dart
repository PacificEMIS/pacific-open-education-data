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
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/utils/string_ext.dart';
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
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(
          fetch: () => _repository.fetchAllSpecialEducation()),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  Future<void> _onDataLoaded(List<SpecialEducation> specialEducations) =>
      launchHandled(() async {
        _lookups = await _repository.lookups.first;
        _specialEducation = specialEducations;
        _filters = await _initFilters();
        _filtersSubject.add(_filters);
        await _updatePageData();
      });

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_SpecialEducationModel, SpecialEducationData>(
        _generateSpecialEducationData,
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

  void onFiltersPressed() {
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return FilterPage(
            filters: _filters,
          );
        },
      ),
    ).then((newFilters) {
      if (newFilters == null) {
        return;
      }
      launchHandled(() async {
        _filters = newFilters;
        await _updatePageData();
      });
    });
  }
}

class _SpecialEducationModel {
  final List<SpecialEducation> specialEducation;
  final Lookups lookups;
  final List<Filter> filters;

  const _SpecialEducationModel(
    this.specialEducation,
    this.lookups,
    this.filters,
  );
}

Future<SpecialEducationData> _generateSpecialEducationData(
  _SpecialEducationModel model,
) async {
  final specialEducationData = model.specialEducation;
  final filteredData = await specialEducationData.applyFilters(model.filters);
  final dataByGender =
      _generateDataByTitle(filteredData.groupBy((it) => it.disability));
  final dataByEthnicity =
      _generateDataByTitle(filteredData.groupBy((it) => it.ethnicityCode));
  final dataBySpecialEdEnvironment =
      _generateDataByTitle(filteredData.groupBy((it) => it.environment));
  final dataByEnglishLearner =
      _generateDataByTitle(filteredData.groupBy((it) => it.englishLearner));

  final dataGroupedByEnvironment =
      specialEducationData.groupBy((it) => it.environment);
  final dataGroupedByDisablility =
      specialEducationData.groupBy((it) => it.disability);
  final dataGroupedByEtnicity =
      specialEducationData.groupBy((it) => it.ethnicityCode);
  final dataGroupedByEnglishLearner =
      specialEducationData.groupBy((it) => it.englishLearner);

  final cohortDataByDistrict = DataByCohortDistribution(
    environment: _generateDataByDistrict(dataGroupedByEnvironment),
    disability: _generateDataByDistrict(dataGroupedByDisablility),
    etnicity: _generateDataByDistrict(dataGroupedByEtnicity),
    englishLearner: _generateDataByDistrict(dataGroupedByEnglishLearner),
  );

  final cohortDataByYear = DataByCohortDistribution(
    environment: _generateDataByYear(dataGroupedByEnvironment),
    disability: _generateDataByYear(dataGroupedByDisablility),
    etnicity: _generateDataByYear(dataGroupedByEtnicity),
    englishLearner: _generateDataByYear(dataGroupedByEnglishLearner),
  );

  final selectedYear = model.filters.firstWhere((it) => it.id == 0).intValue;

  return SpecialEducationData(
    year: selectedYear,
    dataByGender: dataByGender,
    dataByEthnicity: dataByEthnicity,
    dataBySpecialEdEnvironment: dataBySpecialEdEnvironment,
    dataByEnglishLearner: dataByEnglishLearner,
    dataByCohortDistributionByDistrict: cohortDataByDistrict,
    dataByCohortDistributionByYear: cohortDataByYear,
  );
}

List<DataByGroup> _generateDataByTitle(
  Map<String, List<SpecialEducation>> dataGroupedByDisability,
) {
  return dataGroupedByDisability.mapToList((disability, values) {
    var male = 0;
    var female = 0;

    for (var data in values) {
      male += data.gender == 'Male' ? 0 : data.number;
      female += data.gender == 'Female' ? 0 : data.number;
    }
    return DataByGroup(
      title: disability.ifEmpty('labelNa'),
      firstValue: male,
      secondValue: female,
    );
  });
}

List<DataByCohort> _generateDataByDistrict(
  Map<String, List<SpecialEducation>> cohortData,
) {
  return cohortData.mapToList((cohortName, dataList) {
    final groupedByDistrict = dataList.groupBy((it) => it.districtCode);
    final groupDataList = groupedByDistrict.mapToList((districtCode, dataList) {
      final count = dataList.map((e) => e.number).fold(0, (p, n) => p + n);
      return DataByGroup(title: districtCode.ifEmpty('labelNa'), firstValue: count);
    });
    return DataByCohort(
        cohortName: cohortName.ifEmpty('labelNa'), groupDataList: groupDataList);
  });
}

List<DataByCohort> _generateDataByYear(
  Map<String, List<SpecialEducation>> cohortData,
) {
  return cohortData.mapToList((cohortName, dataList) {
    final groupedByYear = dataList.groupBy((it) => it.surveyYear);
    final groupDataList = groupedByYear.mapToList((year, dataList) {
      final count = dataList.map((e) => e.number).fold(0, (p, n) => p + n);
      return DataByGroup(
          title: year.toString(), firstValue: count);
    });
    return DataByCohort(
        cohortName: cohortName.ifEmpty('labelNa'), groupDataList: groupDataList);
  });
}
