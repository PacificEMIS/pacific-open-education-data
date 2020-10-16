import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<SchoolsPageData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  List<School> _schools;
  List<Filter> _filters;
  Lookups _lookups;

  SchoolsViewModel(
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
          ?.moduleConfigFor(Section.schools)
          ?.note;
      _pageNoteSubject.add(note);
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: () => _repository.fetchAllSchools()),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  void _onDataLoaded(List<School> schools) {
    launchHandled(() async {
      _lookups = await _repository.lookups.first;
      _schools = schools;
      _filters = await _initFilters();
      _filtersSubject.add(_filters);
      await _updatePageData();
    });
  }

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_SchoolsModel, SchoolsPageData>(
        _transformSchoolsModel,
        _SchoolsModel(
          _schools,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_schools == null || _lookups == null) {
      return [];
    }
    return _schools.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<SchoolsPageData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _SchoolsModel {
  final List<School> schools;
  final Lookups lookups;
  final List<Filter> filters;

  const _SchoolsModel(this.schools, this.lookups, this.filters);
}

Future<SchoolsPageData> _transformSchoolsModel(
  _SchoolsModel _schoolsModel,
) async {
  final filteredSchools =
      await _schoolsModel.schools.applyFilters(_schoolsModel.filters);

  final schoolsByDistrict = filteredSchools.groupBy((it) => it.districtCode);
  final schoolsByAuthority = filteredSchools.groupBy((it) => it.authorityCode);
  final schoolsByGovt = filteredSchools.groupBy((it) => it.authorityGovt);
  final translates = _schoolsModel.lookups;

  final enrollByDistrictRaw = _calculatePeopleCount(schoolsByDistrict).map(
    (key, v) => MapEntry(key.from(translates.districts), v),
  );
  final enrolByAuthorityRaw = _calculatePeopleCount(schoolsByAuthority).map(
    (key, v) => MapEntry(key.from(translates.authorities), v),
  );
  final enrolByPrivacyRaw = _calculatePeopleCount(schoolsByGovt).map(
    (key, v) => MapEntry(key.from(translates.authorityGovt), v),
  );
  return SchoolsPageData(
    year: _selectedYear(_schoolsModel.filters).toString(),
    enrolByDistrict: enrollByDistrictRaw.mapToList((domain, measure) {
      final domains = enrollByDistrictRaw.keys.toList();
      final index = domains.indexOf(domain);
      final color = index < AppColors.kDynamicPalette.length
          ? AppColors.kDynamicPalette[index]
          : HexColor.fromStringHash(domain);
      return ChartData(
        domain,
        measure,
        color,
      );
    }),
    enrolByAuthority: enrolByAuthorityRaw.mapToList((domain, measure) {
      final domains = enrolByAuthorityRaw.keys.toList();
      final index = domains.indexOf(domain);
      final color = index < AppColors.kDynamicPalette.length
          ? AppColors.kDynamicPalette[index]
          : HexColor.fromStringHash(domain);
      return ChartData(
        domain,
        measure,
        color,
      );
    }),
    enrolByPrivacy: enrolByPrivacyRaw.mapToList((domain, measure) {
      return ChartData(
        domain,
        measure,
        domain.toLowerCase().contains('non')
            ? AppColors.kNonGovernmentChartColor
            : AppColors.kGovernmentChartColor,
      );
    }),
    enrolByAgeAndEducation: _calculateEnrollmentByAgeAndEducation(
      schools: filteredSchools,
      lookups: translates,
    ),
    enrolBySchoolLevelAndDistrict: _calculateEnrolBySchoolLevelAndDistrict(
      schools: filteredSchools,
      lookups: translates,
    ),
  );
}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

Map<String, int> _calculatePeopleCount(
        Map<String, List<School>> groupedSchools) =>
    groupedSchools.map(
      (key, value) => MapEntry(
        key,
        value.map((it) => it.enrol ?? 0).reduce((lv, rv) => lv + rv),
      ),
    );

Map<String, Map<String, GenderTableData>>
    _calculateEnrollmentByAgeAndEducation({
  List<School> schools,
  Lookups lookups,
}) {
  final groupedByLevelWithTotal = {
    'labelTotal': schools,
  };
  groupedByLevelWithTotal.addEntries(schools
      .groupBy((it) => it.classLevel.educationLevelFrom(lookups))
      .entries);

  return groupedByLevelWithTotal.map((level, schools) {
    final groupedByAge =
        _generateInfoTableData(schools.groupBy((it) => it.ageGroup));
    return MapEntry(level, groupedByAge);
  });
}

Map<String, Map<String, GenderTableData>>
    _calculateEnrolBySchoolLevelAndDistrict({
  List<School> schools,
  Lookups lookups,
}) {
  final groupedByDistrictWithTotal = {
    'labelTotal': schools,
  };
  groupedByDistrictWithTotal.addEntries(
    schools.groupBy((it) => it.districtCode).entries,
  );

  return groupedByDistrictWithTotal.map((districtCode, schools) {
    final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
    return MapEntry(districtCode.from(lookups.districts),
        _generateInfoTableData(groupedBySchoolType));
  });
}

Map<String, GenderTableData> _generateInfoTableData(
    Map<String, List<School>> groupedData,
    {String districtCode}) {
  final convertedData = Map<String, GenderTableData>();
  var totalMaleCount = 0;
  var totalFemaleCount = 0;

  groupedData.forEach((group, schools) {
    var maleCount = 0;
    var femaleCount = 0;

    schools
        .where((school) =>
            districtCode == null || school.districtCode == districtCode)
        .forEach((school) {
      switch (school.gender) {
        case Gender.male:
          maleCount += school.enrol ?? 0;
          break;
        case Gender.female:
          femaleCount += school.enrol ?? 0;
          break;
      }
    });

    convertedData[group] = GenderTableData(maleCount, femaleCount);

    totalMaleCount += maleCount;
    totalFemaleCount += femaleCount;
  });

  convertedData['labelTotal'] =
      GenderTableData(totalMaleCount, totalFemaleCount);

  return convertedData;
}
