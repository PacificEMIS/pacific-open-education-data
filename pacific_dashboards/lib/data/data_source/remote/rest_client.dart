import 'package:dio/dio.dart';
import 'package:pacific_dashboards/data/data_source/remote/entities/schools_list/schools_list_response_body.dart';
import 'package:pacific_dashboards/data/data_source/remote/entities/token/token_response_body.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('warehouse/tableenrol')
  Future<List<School>> getSchools();

  @GET('warehouse/teachercount')
  Future<List<Teacher>> getTeachers();

  @GET('warehouse/examsdistrictresults')
  Future<List<Exam>> getExams();

  @GET('warehouse/accreditations/table?byState')
  Future<List<DistrictAccreditation>> getSchoolAccreditationsByDistrict();

  @GET('warehouse/accreditations/table?byStandard')
  Future<List<StandardAccreditation>> getSchoolAccreditationsByStandard();

  @GET('lookups/collection/core')
  Future<Lookups> getLookups();

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
}
