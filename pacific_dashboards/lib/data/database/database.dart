import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

abstract class Database {
  LookupsDao get lookups;
  StringsDao get strings;
  SchoolsDao get schools;
  TeachersDao get teachers;
  ExamsDao get exams;
  AccreditationsDao get accreditations;
}

abstract class LookupsDao {
  Future<void> save(Lookups lookups, Emis emis);
  Future<Pair<bool, Lookups>> get(Emis emis);
}

abstract class StringsDao {
  Future<void> save(String key, String string);
  Future<String> getByKey(String key, {String defaultValue});
}

abstract class SchoolsDao {
  Future<void> save(BuiltList<School> schools, Emis emis);
  Future<BuiltList<School>> get(Emis emis);
}

abstract class TeachersDao {
  Future<void> save(BuiltList<Teacher> teachers, Emis emis);
  Future<Pair<bool, BuiltList<Teacher>>> get(Emis emis);
}

abstract class ExamsDao {
  Future<void> save(BuiltList<Exam> exams, Emis emis);
  Future<Pair<bool, BuiltList<Exam>>> get(Emis emis);
}

abstract class AccreditationsDao {
  Future<void> save(AccreditationChunk chunk, Emis emis);
  Future<AccreditationChunk> get(Emis emis);
}