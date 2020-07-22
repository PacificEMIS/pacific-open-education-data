import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

abstract class RemoteDataSource {
  Future<List<Teacher>> fetchTeachers();

  Future<List<School>> fetchSchools();

  Future<List<Exam>> fetchExams();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();

  Future<Lookups> fetchLookupsModel();

  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(String schoolId);

  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(String districtCode);

  Future<List<SchoolEnroll>> fetchIndividualNationEnroll();

  Future<String> fetchAccessToken();

  Future<List<ShortSchool>> fetchSchoolsList(String accessToken);
}