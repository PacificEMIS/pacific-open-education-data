import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();

  Future<SchoolsModel> fetchAllSchools();

  Future<ExamsModel> fetchAllExams();

  Future<LookupsModel> fetchAllLookups();
}
