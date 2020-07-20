import 'dart:convert';

import 'package:arch/arch.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

const _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm/api/";
const _kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis/api/";
const _kKiribatiUrl = "https://data.moe.gov.ki/kemis/api/";

class RemoteDataSourceImpl implements RemoteDataSource {
  static const platform = const MethodChannel('com.pacific_emis.opendata/api');

  static const _kTeachersApiKey = "warehouse/teachercount";
  static const _kSchoolsApiKey = "warehouse/tableenrol";
  static const _kExamsApiKey = "warehouse/examsdistrictresults";
  static const _kSchoolAccreditationsByStateApiKey =
      "warehouse/accreditations/table?byState";
  static const _kSchoolAccreditationsByStandardApiKey =
      "warehouse/accreditations/table?byStandard";
  static const _kLookupsApiKey = "lookups/collection/core";
  static const _kIndividualSchoolEnrollApiKey = "warehouse/enrol/school/";
  static const _kIndividualDistrictEnrollApiKey = "warehouse/enrol/district/";
  static const _kIndividualNationEnrollApiKey = "warehouse/enrol/electoraten";

  final GlobalSettings _settings;

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 10).inMilliseconds,
    receiveTimeout: Duration(minutes: 1).inMilliseconds,
  ))
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

  RemoteDataSourceImpl(GlobalSettings settings) : _settings = settings;

  Future<String> _get({
    @required String path,
    String restApiParameter,
    Map<String, String> queryParameters,
    bool forced = false,
  }) async {
    final emis = await _settings.currentEmis;
    final requestUrl = '${emis.baseUrl}$path${restApiParameter ?? ''}';
    final existingEtag = forced ? null : await _settings.getEtag(requestUrl);
    var headers = {
      'Accept-Encoding': 'gzip, deflate',
    };
    if (existingEtag != null) {
      headers['If-None-Match'] = existingEtag;
    }
    final options = Options(headers: headers);
    Response<String> response;

    try {
      response = await _dio.get(
        requestUrl,
        options: options,
        queryParameters: queryParameters,
      );
    } on DioError catch (error) {
      print(error.message);
      // https://github.com/flutter/flutter/issues/41573
      if (error.message.contains('full header') ||
          error.message.contains('HttpException: ,')) {
        response = await _fallbackApiGetCall(requestUrl, existingEtag);
      } else {
        throw NoInternetException();
      }
    }

    if (response.statusCode == 304) {
      throw NoNewDataRemoteException(url: requestUrl);
    }

    final responseEtag = response.headers.value("ETag");
    if (responseEtag != null && responseEtag != existingEtag) {
      _settings.setEtag(requestUrl, responseEtag);
    }

    return response.data;
  }

  @override
  Future<List<Teacher>> fetchTeachers() async {
    final responseData = await _get(path: _kTeachersApiKey);
    return compute(_parseTeachersList, responseData);
  }

  static List<Teacher> _parseTeachersList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((it) => Teacher.fromJson(it)).toList();
  }

  @override
  Future<List<School>> fetchSchools() async {
    final responseData = await _get(path: _kSchoolsApiKey);
    return compute(_parseSchoolsList, responseData);
  }

  static List<School> _parseSchoolsList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((it) => School.fromJson(it)).toList();
  }

  @override
  Future<List<Exam>> fetchExams() async {
    final responseData = await _get(path: _kExamsApiKey);
    return compute(_parseExamsList, responseData);
  }

  static List<Exam> _parseExamsList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((it) => Exam.fromJson(it)).toList();
  }

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async {
    final byStandardData =
        await _get(path: _kSchoolAccreditationsByStandardApiKey);
    final byDistrictData =
        await _get(path: _kSchoolAccreditationsByStateApiKey);
    return compute(
        _parseAccreditationData,
        AccreditationChunkJsonParts(
          byDistrictJsonString: byDistrictData,
          byStandardJsonString: byStandardData,
        ));
  }

  static AccreditationChunk _parseAccreditationData(
      AccreditationChunkJsonParts parts) {
    final List<dynamic> standardData = json.decode(parts.byStandardJsonString);
    final List<dynamic> districtData = json.decode(parts.byDistrictJsonString);
    return AccreditationChunk(
      byDistrict:
          districtData.map((it) => DistrictAccreditation.fromJson(it)).toList(),
      byStandard:
          standardData.map((it) => StandardAccreditation.fromJson(it)).toList(),
    );
  }

  @override
  Future<Lookups> fetchLookupsModel() async {
    final responseData = await _get(
        path: _kLookupsApiKey,
        forced: true); // TODO: deprecated. forced disables ETag
    return compute(_parseLookups, responseData);
  }

  static Lookups _parseLookups(String jsonString) {
    final data = json.decode(jsonString);
    return Lookups.fromJson(data);
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(
    String schoolId,
  ) async {
    final responseData = await _get(
      path: _kIndividualSchoolEnrollApiKey,
      restApiParameter: '$schoolId?report',
    );
    return compute(_parseSchoolEnrollList, responseData);
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(
    String districtCode,
  ) async {
    final responseData = await _get(
      path: _kIndividualDistrictEnrollApiKey,
      restApiParameter: '$districtCode?report',
    );
    return compute(_parseSchoolEnrollList, responseData);
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualNationEnroll() async {
    final responseData = await _get(
      path: _kIndividualNationEnrollApiKey,
      restApiParameter: '?report',
    );
    return compute(_parseSchoolEnrollList, responseData);
  }

  static List<SchoolEnroll> _parseSchoolEnrollList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((it) => SchoolEnroll.fromJson(it)).toList();
  }

  Future<Response<String>> _fallbackApiGetCall(String url, String eTag) async {
    try {
      final Map result = await platform.invokeMethod('apiGet', {
        'url': url,
        'eTag': eTag,
      });
      print(result);
      final response = Response<String>(
        headers: Headers.fromMap({
          'ETag': [result['eTag']]
        }),
        statusCode: result['code'],
        data: result['body'],
      );
      return response;
    } catch (error) {
      print(error);
      throw UnknownRemoteException(url: url);
    }
  }
}

extension Urls on Emis {
  String get baseUrl {
    switch (this) {
      case Emis.miemis:
        return _kMarshalIslandsUrl;
      case Emis.fedemis:
        return _kFederalStatesOfMicronesiaUrl;
      case Emis.kemis:
        return _kKiribatiUrl;
    }
    throw FallThroughError();
  }
}
