import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'package:pacific_dashboards/models/indicators/indicators.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
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

abstract class RemoteDataSource {
  Future<List<Teacher>> fetchTeachers();

  Future<List<School>> fetchSchools();

  Future<List<Exam>> fetchExams();

  Future<IndicatorsContainer> fetchIndicators(String districtCode);

  Future<List<Budget>> fetchBudgets();

  Future<List<SpecialEducation>> fetchSpecialEducation();

  Future<AccreditationChunk> fetchSchoolAccreditationsChunk();

  Future<WashChunk> fetchWashChunk();

  Future<Lookups> fetchLookupsModel();

  Future<FinancialLookups> fetchFinancialLookupsModel();

  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(String schoolId);

  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(String districtCode);

  Future<List<SchoolEnroll>> fetchIndividualNationEnroll();

  Future<String> fetchAccessToken();

  Future<List<ShortSchool>> fetchSchoolsList(String accessToken);

  Future<List<SchoolFlow>> fetchSchoolFlow(String schoolId);

  Future<List<SchoolExamReport>> fetchSchoolExamReports(String schoolId);

  Future<IndividualSchool> fetchIndividualSchool(
    String accessToken,
    String schoolId,
  );
}
