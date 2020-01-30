import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

class LocalDataSourceImpl extends LocalDataSource {
  final Database _database;
  final GlobalSettings _globalSettings;

  LocalDataSourceImpl(this._database, this._globalSettings);

  Future<Emis> get _emis => _globalSettings.currentEmis;

  @override
  Future<BuiltList<School>> fetchSchools() async =>
      await _database.schools.get(await _emis);

  @override
  Future<Pair<bool, BuiltList<Teacher>>> fetchTeachers() async =>
      await _database.teachers.get(await _emis);

  @override
  Future<Pair<bool, BuiltList<Exam>>> fetchExams() async =>
      await _database.exams.get(await _emis);

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async =>
      await _database.accreditations.get(await _emis);

  @override
  Future<Pair<bool, Lookups>> fetchLookupsModel() async =>
      await _database.lookups.get(await _emis);

  @override
  Future<void> saveSchools(BuiltList<School> schools) async =>
      await _database.schools.save(schools, await _emis);

  @override
  Future<void> saveTeachers(BuiltList<Teacher> teachers) async =>
      await _database.teachers.save(teachers, await _emis);

  @override
  Future<void> saveExams(BuiltList<Exam> exams) async =>
      await _database.exams.save(exams, await _emis);

  @override
  Future<void> saveSchoolAccreditationsChunk(AccreditationChunk chunk) async =>
      await _database.accreditations.save(chunk, await _emis);

  @override
  Future<void> saveLookupsModel(Lookups model) async =>
      await _database.lookups.save(model, await _emis);
}
