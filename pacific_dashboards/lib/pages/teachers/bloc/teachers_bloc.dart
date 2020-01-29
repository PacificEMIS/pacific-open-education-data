import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/teachers/teacher.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';
import 'package:pacific_dashboards/utils/collections.dart';
import './bloc.dart';

class TeachersBloc extends BaseBloc<TeachersEvent, TeachersState> {
  TeachersBloc({Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;

  BuiltList<Teacher> _teachers;
  BuiltList<Filter> _filters;

  @override
  TeachersState get initialState => InitialTeachersState();

  @override
  TeachersState get serverUnavailableState => ServerUnavailableState();

  @override
  TeachersState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookupsStream => _repository.lookups;

  @override
  Stream<TeachersState> mapEventToState(
    TeachersEvent event,
  ) async* {
    if (event is StartedTeachersEvent) {
      final currentState = state;
      yield LoadingTeachersState();
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllTeachers,
        onSuccess: (data) async* {
          _teachers = data;
          _filters = await _initFilters();
          yield UpdatedTeachersState(await _transformTeachersModel());
        },
      );
    }

    if (event is FiltersAppliedTeachersEvent) {
      _filters = event.filters;
      yield UpdatedTeachersState(await _transformTeachersModel());
    }
  }

  Future<BuiltList<Filter>> _initFilters() async {
    if (_teachers == null) {
      return null;
    }
    return _teachers.generateDefaultFilters(await lookups);
  }

  Future<TeachersPageData> _transformTeachersModel() async {
    final filteredTeachers = await _teachers.applyFilters(_filters);
    final teachersByDistrict =
        filteredTeachers.groupBy((it) => it.districtCode);
    final teachersByAuthority =
        filteredTeachers.groupBy((it) => it.authorityCode);
    final teachersByGovt = filteredTeachers.groupBy((it) => it.authorityGovt);

    final translates = await lookups;

    return TeachersPageData(
      teachersByDistrict:
          _calculatePeopleCount(teachersByDistrict).map((key, v) {
        return MapEntry(key.from(translates.districts), v);
      }),
      teachersByAuthority:
          _calculatePeopleCount(teachersByAuthority).map((key, v) {
        return MapEntry(key.from(translates.authorities), v);
      }),
      teachersByPrivacy: _calculatePeopleCount(teachersByGovt).map((key, v) {
        return MapEntry(key.from(translates.authorityGovt), v);
      }),
      teachersBySchoolLevelStateAndGender:
          _calculateEnrolBySchoolLevelAndDistrict(
        teachers: filteredTeachers,
        lookups: translates,
      ),
      filters: _filters,
    );
  }

  BuiltMap<String, int> _calculatePeopleCount(
          BuiltMap<String, BuiltList<Teacher>> groupedTeachers) =>
      groupedTeachers.map(
        (key, value) => MapEntry(
            key,
            value
                .map((it) => it.totalTeachersCount)
                .reduce((lv, rv) => lv + rv)),
      );

  BuiltMap<String, BuiltMap<String, InfoTableData>>
      _calculateEnrolBySchoolLevelAndDistrict({
    BuiltList<Teacher> teachers,
    Lookups lookups,
  }) {
    final groupedByDistrictWithTotal = {AppLocalizations.total: teachers};
    groupedByDistrictWithTotal.addEntries(
      teachers.groupBy((it) => it.districtCode).entries,
    );

    return groupedByDistrictWithTotal.map((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      return MapEntry(districtCode.from(lookups.districts),
          _generateInfoTableData(groupedBySchoolType));
    }).build();
  }

  BuiltMap<String, InfoTableData> _generateInfoTableData(
      BuiltMap<String, BuiltList<Teacher>> groupedData,
      {String districtCode}) {
    final convertedData = Map<String, InfoTableData>();
    var totalMaleCount = 0;
    var totalFemaleCount = 0;

    groupedData.forEach((group, teachers) {
      var maleCount = 0;
      var femaleCount = 0;

      teachers
          .where((teacher) =>
              districtCode == null || teacher.districtCode == districtCode)
          .forEach((teacher) {
        maleCount += teacher.getTeachersCount(Gender.male);
        femaleCount += teacher.getTeachersCount(Gender.female);
      });

      convertedData[group] = InfoTableData(maleCount, femaleCount);

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;
    });

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData.build();
  }
}
