import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

abstract class LocalDataSource {
  Future<Pair<bool, List<Teacher>>> fetchTeachers();

  Future<List<School>> fetchSchools();

  Future<Pair<bool, List<Exam>>> fetchExams();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();

  Future<Pair<bool, Lookups>> fetchLookupsModel();

  Future<void> saveExams(List<Exam> exams);

  Future<void> saveTeachers(List<Teacher> teachers);

  Future<void> saveSchools(List<School> schools);

  Future<void> saveSchoolAccreditationsChunk(AccreditationChunk chunk);

  Future<void> saveLookupsModel(Lookups model);

  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(String schoolId);

  Future<void> saveIndividualSchoolEnroll(
    String schoolId,
    List<SchoolEnroll> enroll,
  );

  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(String districtCode);

  Future<void> saveIndividualDistrictEnroll(
    String districtCode,
    List<SchoolEnroll> enroll,
  );

  Future<List<SchoolEnroll>> fetchIndividualNationEnroll();

  Future<void> saveIndividualNationEnroll(
    List<SchoolEnroll> enroll,
  );
}
