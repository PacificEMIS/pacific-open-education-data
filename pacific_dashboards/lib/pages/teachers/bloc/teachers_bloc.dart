import 'dart:async';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/teacher_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';
import './bloc.dart';

class TeachersBloc extends BaseBloc<TeachersEvent, TeachersState> {
  TeachersBloc({Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;

  TeachersModel _teachersModel;

  @override
  TeachersState get initialState => InitialTeachersState();

  @override
  TeachersState get serverUnavailableState => ServerUnavailableState();

  @override
  TeachersState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookups => _repository.lookups;

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
          _teachersModel = data;
          yield UpdatedTeachersState(await _transformTeachersModel());
        },
      );
    }

    if (event is FiltersAppliedTeachersEvent) {
      _teachersModel = event.updatedModel;
      yield UpdatedTeachersState(await _transformTeachersModel());
    }
  }

  Future<TeachersPageData> _transformTeachersModel() async {
    return TeachersPageData(
      rawModel: _teachersModel,
      teachersByState:
          _calculatePeopleCount(_teachersModel.getGroupedByStateWithFilters()),
      teachersByAuthority: _calculatePeopleCount(
          _teachersModel.getGroupedByAuthorityWithFilters()),
      teachersByPrivacy:
          _calculatePeopleCount(_teachersModel.getGroupedByGovtWithFilters()),
      teachersBySchoolLevelStateAndGender:
          _calculateTeachersBySchoolLevelStateAndGender(),
    );
  }

  Map<String, int> _calculatePeopleCount(
          Map<String, List<TeacherModel>> groupedSchoolModels) =>
      groupedSchoolModels.map(
        (key, value) => MapEntry(
            key,
            value
                .map((it) => it.numTeachersM + it.numTeachersF)
                .reduce((lv, rv) => lv + rv)),
      );

  Map<String, Map<String, InfoTableData>>
      _calculateTeachersBySchoolLevelStateAndGender() {
    final enrollment = Map<String, Map<String, InfoTableData>>();
    final districtKeys = _teachersModel.getDistrictCodeKeys();
    final filteredData = _teachersModel.getGroupedBySchoolTypeWithFilters();

    enrollment[AppLocalizations.total] = _generateInfoTableData(filteredData);

    districtKeys.forEach((district) {
      enrollment[district] =
          _generateInfoTableData(filteredData, districtCode: district);
    });

    return enrollment;
  }

  Map<String, InfoTableData> _generateInfoTableData(
      Map<String, List<TeacherModel>> groupedData,
      {String districtCode}) {
    final convertedData = Map<String, InfoTableData>();
    var totalMaleCount = 0;
    var totalFemaleCount = 0;

    groupedData.forEach((group, teachers) {
      var maleCount = 0;
      var femaleCount = 0;

      teachers
          .where((school) =>
              districtCode == null || school.districtCode == districtCode)
          .forEach((school) {
        maleCount += school.numTeachersM;
        femaleCount += school.numTeachersF;
      });

      convertedData[group] = InfoTableData(maleCount, femaleCount);

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;
    });

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData;
  }
}
