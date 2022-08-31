import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pacific_dashboards/data/data_source/remote/entities/individual_school/individual_school_response.dart';
import 'package:pacific_dashboards/data/data_source/remote/entities/schools_list/schools_list_response_body.dart';
import 'package:pacific_dashboards/data/data_source/remote/entities/token/token_response_body.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/national_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/exam/exam_separated.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/models/wash/question.dart';
import 'package:pacific_dashboards/models/wash/toilets.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/models/wash/water.dart';
import 'package:retrofit/retrofit.dart';
import '../../../models/lookups/lookups.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('warehouse/enrol/district')
  Future<List<School>> getSchools();

  @GET('warehouse/enrol/authority')
  Future<List<School>> getSchoolsAuthority();

  @GET('warehouse/teachers?report')
  Future<List<Teacher>> getTeachers();

  @GET('warehouse/exams/table')
  Future<List<ExamSeparated>> getExamsSeparated();

  @GET('indicators/{districtCode}?format=xml')
  Future<IndicatorsContainer> getIndicators(
    @Path('districtCode') String districtCode,
  );

  @GET('warehouse/accreditations/table?byState')
  Future<List<DistrictAccreditation>> getSchoolAccreditationsByDistrict();

  @GET('warehouse/accreditations/table?byStandard')
  Future<List<StandardAccreditation>> getSchoolAccreditationsByStandard();

  @GET('warehouse/accreditations/table?result')
  Future<List<NationalAccreditation>> getSchoolAccreditationsByNation();

  @GET('lookups/collection/core')
  Future<Lookups> getLookups();

  @GET('warehouse/wash/questions')
  Future<List<Question>> getWashQuestions();

  @GET('lookups/collection/findata')
  Future<FinancialLookups> getFinanceLookups();

  @GET('warehouse/enrol/school/{schoolId}?report')
  Future<List<SchoolEnroll>> getIndividualSchoolEnroll(
    @Path('schoolId') String schoolId,
  );

  @GET('warehouse/enrol/district/{districtCode}?report')
  Future<List<SchoolEnroll>> getIndividualDistrictEnroll(
    @Path('districtCode') String districtCode,
  );

  @GET('warehouse/enrol/nation?report')
  Future<List<SchoolEnroll>> getIndividualNationEnroll();

  @POST('token')
  @FormUrlEncoded()
  Future<TokenResponseBody> getToken(
    @Field('grant_type') String grantType,
    @Field('username') String username,
    @Field('password') String password,
  );

  @GET('schools')
  Future<SchoolsListResponseBody> getSchoolsList(
    @Header('Authorization') String bearerToken,
    @Query('PageSize') int pageSize,
  );

  @GET('warehouse/flow/school/{schoolId}?report&asperc')
  Future<List<SchoolFlow>> getSchoolFlow(@Path('schoolId') String schoolId);

  @GET('warehouse/exams/school/{schoolId}?report')
  Future<List<SchoolExamReport>> getSchoolExamReports(
    @Path('schoolId') String schoolId,
  );

  @GET('warehouse/finance')
  Future<List<Budget>> getBudgets();

  @GET('warehouse/specialeducation')
  Future<List<SpecialEducation>> getSpecialEducation();

  @GET('warehouse/wash')
  Future<List<Wash>> getWashGlobalData();

  @GET('warehouse/wash/toilets')
  Future<List<Toilets>> getWashToilets();

  @GET('warehouse/wash/water')
  Future<List<Water>> getWashWater();

  @GET('schools/{schoolId}')
  Future<IndividualSchoolResponse> getIndividualSchool(
    @Header('Authorization') String bearerToken,
    @Path('schoolId') String schoolId,
  );
}
