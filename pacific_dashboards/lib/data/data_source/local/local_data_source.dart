import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

abstract class LocalDataSource {

  Future<Pair<bool, BuiltList<Teacher>>> fetchTeachers();

  Future<BuiltList<School>> fetchSchools();

  Future<Pair<bool, BuiltList<Exam>>> fetchExams();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();

  Future<Pair<bool, Lookups>> fetchLookupsModel();

  Future<void> saveExams(BuiltList<Exam> exams);

  Future<void> saveTeachers(BuiltList<Teacher> teachers);

  Future<void> saveSchools(BuiltList<School> schools);

  Future<void> saveSchoolAccreditationsChunk(AccreditationChunk chunk);

  Future<void> saveLookupsModel(Lookups model);
}
