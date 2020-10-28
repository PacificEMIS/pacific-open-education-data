import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';

abstract class LocalDataSource {
  Future<Pair<bool, List<Teacher>>> fetchTeachers();

  Future<List<School>> fetchSchools();

  Future<List<Budget>> fetchBudgets();

  Future<List<SpecialEducation>> fetchSpecialEducation();

  Future<Pair<bool, List<Exam>>> fetchExams();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();

  Future<WashChunk> fetchWashChunk();

  Future<Pair<bool, Lookups>> fetchLookupsModel();

  Future<Pair<bool, FinancialLookups>> fetchFinancialLookupsModel();

  Future<void> saveExams(List<Exam> exams);

  Future<void> saveTeachers(List<Teacher> teachers);

  Future<void> saveSchools(List<School> schools);

  Future<void> saveSchoolAccreditationsChunk(AccreditationChunk chunk);

  Future<void> saveWashChunk(WashChunk chunk);

  Future<void> saveLookupsModel(Lookups model);

  Future<void> saveFinancialLookupsModel(FinancialLookups model);

  Future<void> saveBudgets(List<Budget> budgets);

  Future<void> saveSpecialEducation(List<SpecialEducation> specialEducation);

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

  Future<void> saveAccessToken(String token);

  Future<String> fetchAccessToken();

  Future<List<ShortSchool>> fetchSchoolsList();

  Future<void> saveSchoolsList(List<ShortSchool> schools);

  Future<List<SchoolFlow>> fetchSchoolFlow(String schoolId);

  Future<void> saveSchoolFlow(String schoolId, List<SchoolFlow> schoolFlows);

  Future<List<SchoolExamReport>> fetchSchoolExamReports(String schoolId);

  Future<void> saveSchoolExamReports(
    String schoolId,
    List<SchoolExamReport> reports,
  );

  Future<IndividualSchool> fetchIndividualSchool(String schoolId);

  Future<void> saveIndividualSchool(String schoolId, IndividualSchool school);
}
