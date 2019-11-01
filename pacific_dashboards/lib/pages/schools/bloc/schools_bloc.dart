import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/models/school_model.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import './bloc.dart';

class SchoolsBloc extends Bloc<SchoolsEvent, SchoolsState> {
  SchoolsBloc({Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;

  SchoolsModel _schoolsModel;

  @override
  SchoolsState get initialState => LoadingSchoolsState();

  @override
  Stream<SchoolsState> mapEventToState(
    SchoolsEvent event,
  ) async* {
    if (event is StartedSchoolsEvent) {
      _schoolsModel = await _repository.fetchAllSchools();
      yield LoadedSchoolsState(await _transformSchoolsModel());
    }
  }

  Future<SchoolsPageData> _transformSchoolsModel() async {
    final enrollmentByState =
        _calculatePeopleCount(_schoolsModel.getSortedWithFiltersByState());
    final enrollmentByAuthority =
        _calculatePeopleCount(_schoolsModel.getSortedWithFiltersByAuthority());
    final enrollmentByPrivacy =
        _calculatePeopleCount(_schoolsModel.getSortedWithFiltersByGovt());

    return SchoolsPageData(
      enrollmentByState: enrollmentByState,
      enrollmentByAuthority: enrollmentByAuthority,
      enrollmentByPrivacy: enrollmentByPrivacy,
      enrollmentByAgeAndEducation: {},
      enrollmentBySchoolLevelAndState: {},
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
}
