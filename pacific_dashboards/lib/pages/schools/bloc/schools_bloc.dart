import 'dart:async';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school_model.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class SchoolsBloc extends BaseBloc<SchoolsEvent, SchoolsState> {
  SchoolsBloc({Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;

  SchoolsModel _schoolsModel;

  @override
  SchoolsState get initialState => InitialSchoolsState();

  @override
  SchoolsState get serverUnavailableState => ServerUnavailableState();

  @override
  SchoolsState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookups => _repository.lookups;

  @override
  Stream<SchoolsState> mapEventToState(SchoolsEvent event) async* {
    if (event is StartedSchoolsEvent) {
      final currentState = state;
      yield LoadingSchoolsState();
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllSchools,
        onSuccess: (data) async* {
          _schoolsModel = data;
          yield UpdatedSchoolsState(await _transformSchoolsModel());
        },
      );
    }

    if (event is FiltersAppliedSchoolsEvent) {
      _schoolsModel = event.updatedModel;
      yield UpdatedSchoolsState(await _transformSchoolsModel());
    }
  }

  Future<SchoolsPageData> _transformSchoolsModel() async {
    return SchoolsPageData(
      rawModel: _schoolsModel,
      enrollmentByState:
          _calculatePeopleCount(_schoolsModel.getSortedWithFiltersByState()),
      enrollmentByAuthority: _calculatePeopleCount(
          _schoolsModel.getSortedWithFiltersByAuthority()),
      enrollmentByPrivacy:
          _calculatePeopleCount(_schoolsModel.getSortedWithFiltersByGovt()),
      enrollmentByAgeAndEducation: _calculateEnrollmentByAgeAndEducation(),
      enrollmentBySchoolLevelAndState:
          _calculateEnrollmentBySchoolLevelAndState(),
    );
  }

  Map<String, int> _calculatePeopleCount(
          Map<String, List<SchoolModel>> groupedSchoolModels) =>
      groupedSchoolModels.map(
        (key, value) => MapEntry(
            key,
            value
                .map((it) => it.enrolMale + it.enrolFemale)
                .reduce((lv, rv) => lv + rv)),
      );

  Map<String, Map<String, InfoTableData>>
      _calculateEnrollmentByAgeAndEducation() {
    final enrollment = Map<String, Map<String, InfoTableData>>();
    final educationLevels = [
      EducationLevel.all,
      EducationLevel.earlyChildhood,
      EducationLevel.primary,
      EducationLevel.secondary,
      EducationLevel.postSecondary
    ];

    for (var i = 0; i < educationLevels.length; i++) {
      final level = educationLevels[i];
      final levelName = _educationLevelToString(level);
      enrollment[levelName] = _generateInfoTableData(
        _schoolsModel.getGroupedByAgeFileteredByEducationLevel(level),
      );
    }

    return enrollment;
  }

  String _educationLevelToString(EducationLevel level) {
    switch (level) {
      case EducationLevel.all:
        return AppLocalizations.total;
      case EducationLevel.earlyChildhood:
        return AppLocalizations.earlyChildhood;
      case EducationLevel.primary:
        return AppLocalizations.primary;
      case EducationLevel.secondary:
        return AppLocalizations.secondary;
      case EducationLevel.postSecondary:
        return AppLocalizations.postSecondary;
    }
    return null;
  }

  Map<String, InfoTableData> _generateInfoTableData(
      Map<String, List<SchoolModel>> groupedData,
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
        maleCount += school.enrolMale;
        femaleCount += school.enrolFemale;
      });

      convertedData[group] = InfoTableData(maleCount, femaleCount);

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;
    });

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData;
  }

  Map<String, Map<String, InfoTableData>>
      _calculateEnrollmentBySchoolLevelAndState() {
    final enrollment = Map<String, Map<String, InfoTableData>>();
    final districtKeys = _schoolsModel.getDistrictCodeKeysList();
    final filteredData = _schoolsModel.getSortedWithFilteringBySchoolType();

    enrollment[AppLocalizations.total] = _generateInfoTableData(filteredData);

    districtKeys.forEach((district) {
      enrollment[district] =
          _generateInfoTableData(filteredData, districtCode: district);
    });

    return enrollment;
  }
}
