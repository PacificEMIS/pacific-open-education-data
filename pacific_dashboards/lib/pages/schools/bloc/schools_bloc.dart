import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/home/section.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';
import 'package:pacific_dashboards/utils/collections.dart';

class SchoolsBloc extends BaseBloc<SchoolsEvent, SchoolsState> {
  SchoolsBloc({
    Repository repository,
    RemoteConfig remoteConfig,
    GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings;

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  BuiltList<School> _schools;
  BuiltList<Filter> _filters;
  String _note;

  @override
  SchoolsState get initialState => InitialSchoolsState();

  @override
  SchoolsState get serverUnavailableState => ServerUnavailableState();

  @override
  SchoolsState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookupsStream => _repository.lookups;

  @override
  Stream<SchoolsState> mapEventToState(SchoolsEvent event) async* {
    if (event is StartedSchoolsEvent) {
      final currentState = state;
      yield LoadingSchoolsState();
      _note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.schools)
          ?.note;
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllSchools,
        onSuccess: (data) async* {
          _schools = data;
          _filters = await _initFilters();
          yield UpdatedSchoolsState(await _transformSchoolsModel());
        },
      );
    }

    if (event is FiltersAppliedSchoolsEvent) {
      _filters = event.filters;
      yield UpdatedSchoolsState(await _transformSchoolsModel());
    }
  }

  Future<SchoolsPageData> _transformSchoolsModel() async {
    final filteredSchools = await _schools.applyFilters(_filters);

    final schoolsByDistrict = filteredSchools.groupBy((it) => it.districtCode);
    final schoolsByAuthority =
        filteredSchools.groupBy((it) => it.authorityCode);
    final schoolsByGovt = filteredSchools.groupBy((it) => it.authorityGovt);
    final translates = await lookups;
    return SchoolsPageData(
      enrolByDistrict: _calculatePeopleCount(schoolsByDistrict).map((key, v) {
        return MapEntry(key.from(translates.districts), v);
      }),
      enrolByAuthority: _calculatePeopleCount(schoolsByAuthority).map((key, v) {
        return MapEntry(key.from(translates.authorities), v);
      }),
      enrolByPrivacy: _calculatePeopleCount(schoolsByGovt).map((key, v) {
        return MapEntry(key.from(translates.authorityGovt), v);
      }),
      enrolByAgeAndEducation: _calculateEnrollmentByAgeAndEducation(
        schools: filteredSchools,
        lookups: translates,
      ),
      enrolBySchoolLevelAndDistrict: _calculateEnrolBySchoolLevelAndDistrict(
        schools: filteredSchools,
        lookups: translates,
      ),
      filters: _filters,
      note: _note,
    );
  }

  BuiltMap<String, int> _calculatePeopleCount(
          BuiltMap<String, BuiltList<School>> groupedSchools) =>
      groupedSchools.map(
        (key, value) => MapEntry(
          key,
          value.map((it) => it.enrol ?? 0).reduce((lv, rv) => lv + rv),
        ),
      );

  BuiltMap<String, BuiltMap<String, InfoTableData>>
      _calculateEnrollmentByAgeAndEducation({
    BuiltList<School> schools,
    Lookups lookups,
  }) {
    final groupedByLevelWithTotal = {AppLocalizations.total: schools};
    groupedByLevelWithTotal.addEntries(schools
        .groupBy((it) => it.classLevel.educationLevelFrom(lookups))
        .entries);

    return groupedByLevelWithTotal.map((level, schools) {
      final groupedByAge =
          _generateInfoTableData(schools.groupBy((it) => it.ageGroup));
      return MapEntry(level, groupedByAge);
    }).build();
  }

  BuiltMap<String, BuiltMap<String, InfoTableData>>
      _calculateEnrolBySchoolLevelAndDistrict({
    BuiltList<School> schools,
    Lookups lookups,
  }) {
    final groupedByDistrictWithTotal = {AppLocalizations.total: schools};
    groupedByDistrictWithTotal.addEntries(
      schools.groupBy((it) => it.districtCode).entries,
    );

    return groupedByDistrictWithTotal.map((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      return MapEntry(districtCode.from(lookups.districts),
          _generateInfoTableData(groupedBySchoolType));
    }).build();
  }

  BuiltMap<String, InfoTableData> _generateInfoTableData(
      BuiltMap<String, BuiltList<School>> groupedData,
      {String districtCode}) {
    final convertedData = Map<String, InfoTableData>();
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

      convertedData[group] = InfoTableData(maleCount, femaleCount);

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;
    });

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData.build();
  }

  Future<BuiltList<Filter>> _initFilters() async {
    if (_schools == null) {
      return null;
    }
    return _schools.generateDefaultFilters(await lookups);
  }
}
