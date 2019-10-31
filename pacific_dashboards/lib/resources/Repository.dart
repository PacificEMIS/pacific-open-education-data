import 'package:pacific_dashboards/models/ExamsModel.dart';
import 'package:pacific_dashboards/models/LookupsModel.dart';
import 'package:pacific_dashboards/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/models/SchoolsModel.dart';
import 'package:pacific_dashboards/models/TeachersModel.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();

  Future<SchoolsModel> fetchAllSchools();

  Future<ExamsModel> fetchAllExams();

  Future<LookupsModel> fetchAllLookups();

  Future<SchoolAccreditationsChunk> fetchAllAccreditaitons();
}