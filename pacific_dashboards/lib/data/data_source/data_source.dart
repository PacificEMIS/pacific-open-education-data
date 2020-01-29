import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/teachers/teacher.dart';

abstract class DataSource {
  Future<BuiltList<Teacher>> fetchTeachers();

  Future<BuiltList<School>> fetchSchools();

  Future<ExamsModel> fetchExamsModel();

  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk();
  
  Future<Lookups> fetchLookupsModel();
}