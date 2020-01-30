import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

abstract class DataSource {
  Future<BuiltList<Teacher>> fetchTeachers();

  Future<BuiltList<School>> fetchSchools();

  Future<BuiltList<Exam>> fetchExams();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();
  
  Future<Lookups> fetchLookupsModel();
}