import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();

  Future<SchoolsModel> fetchAllSchools();

  Future<ExamsModel> fetchAllExams();

  Future<LookupsModel> fetchAllLookups();

  Future<SchoolAccreditationsChunk> fetchAllAccreditaitons();
}