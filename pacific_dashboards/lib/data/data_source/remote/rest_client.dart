import 'package:dio/dio.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

const _ETagHeader = 'If-None-Match';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("warehouse/tableenrol")
  Future<List<School>> getSchools(@Header(_ETagHeader) eTag);

  @GET("warehouse/tableenrol")
  Future<List<Teacher>> getSchools(@Header(_ETagHeader) eTag);
}