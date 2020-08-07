import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

const _kAccessTokenKey = '_kAccessTokenKey';

class LocalDataSourceImpl extends LocalDataSource {
  final Database _database;
  final GlobalSettings _globalSettings;

  LocalDataSourceImpl(this._database, this._globalSettings);

  Future<Emis> get _emis => _globalSettings.currentEmis;

  @override
  Future<List<School>> fetchSchools() async =>
      await _database.schools.get(await _emis);

  @override
  Future<Pair<bool, List<Teacher>>> fetchTeachers() async =>
      await _database.teachers.get(await _emis);

  @override
  Future<Pair<bool, List<Exam>>> fetchExams() async =>
      await _database.exams.get(await _emis);

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async =>
      await _database.accreditations.get(await _emis);

  @override
  Future<Pair<bool, Lookups>> fetchLookupsModel() async =>
      await _database.lookups.get(await _emis);

  @override
  Future<void> saveSchools(List<School> schools) async =>
      await _database.schools.save(schools, await _emis);

  @override
  Future<void> saveTeachers(List<Teacher> teachers) async =>
      await _database.teachers.save(teachers, await _emis);

  @override
  Future<void> saveExams(List<Exam> exams) async =>
      await _database.exams.save(exams, await _emis);

  @override
  Future<void> saveSchoolAccreditationsChunk(AccreditationChunk chunk) async =>
      await _database.accreditations.save(chunk, await _emis);

  @override
  Future<void> saveLookupsModel(Lookups model) async =>
      await _database.lookups.save(model, await _emis);

  @override
  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(
          String schoolId) async =>
      await _database.schoolEnroll.get(schoolId, await _emis);

  @override
  Future<void> saveIndividualSchoolEnroll(
    String schoolId,
    List<SchoolEnroll> enroll,
  ) async =>
      await _database.schoolEnroll.save(schoolId, enroll, await _emis);

  @override
  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(
    String districtCode,
  ) async =>
      await _database.districtEnroll.get(districtCode, await _emis);

  @override
  Future<void> saveIndividualDistrictEnroll(
    String districtCode,
    List<SchoolEnroll> enroll,
  ) async =>
      await _database.districtEnroll.save(
        districtCode,
        enroll,
        await _emis,
      );

  @override
  Future<List<SchoolEnroll>> fetchIndividualNationEnroll() async =>
      await _database.nationEnroll.get(await _emis);

  @override
  Future<void> saveIndividualNationEnroll(List<SchoolEnroll> enroll) async =>
      _database.nationEnroll.save(enroll, await _emis);

  @override
  Future<String> fetchAccessToken() =>
      _database.strings.getByKey(_kAccessTokenKey);

  @override
  Future<void> saveAccessToken(String token) async =>
      _database.strings.save(_kAccessTokenKey, token);

  @override
  Future<List<ShortSchool>> fetchSchoolsList() async =>
      await _database.shortSchool.get(await _emis);

  @override
  Future<void> saveSchoolsList(List<ShortSchool> schools) async =>
      _database.shortSchool.save(schools, await _emis);

  @override
  Future<List<SchoolFlow>> fetchSchoolFlow(String schoolId) async =>
      await _database.schoolFlow.get(schoolId, await _emis);

  @override
  Future<void> saveSchoolFlow(
          String schoolId, List<SchoolFlow> schoolFlows) async =>
      await _database.schoolFlow.save(schoolId, schoolFlows, await _emis);

  @override
  Future<List<SchoolExamReport>> fetchSchoolExamReports(
    String schoolId,
  ) async =>
      await _database.schoolExamReports.get(schoolId, await _emis);

  @override
  Future<void> saveSchoolExamReports(
    String schoolId,
    List<SchoolExamReport> reports,
  ) async =>
      await _database.schoolExamReports.save(schoolId, reports, await _emis);
}
