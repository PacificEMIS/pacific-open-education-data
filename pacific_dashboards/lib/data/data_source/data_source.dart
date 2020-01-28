import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

abstract class DataSource {
  Future<TeachersModel> fetchTeachersModel();

  Future<BuiltList<School>> fetchSchoolsModel();

  Future<ExamsModel> fetchExamsModel();

  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk();
  
  Future<Lookups> fetchLookupsModel();
}