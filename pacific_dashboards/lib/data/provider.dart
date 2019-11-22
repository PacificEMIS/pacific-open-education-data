import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

abstract class Provider {
  Future<TeachersModel> fetchTeachersModel();

  Future<SchoolsModel> fetchSchoolsModel();

  Future<ExamsModel> fetchExamsModel();

  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk();
  
  Future<LookupsModel> fetchLookupsModel();
}