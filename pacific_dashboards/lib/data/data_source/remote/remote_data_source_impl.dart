import 'dart:async';
import 'dart:convert';

import 'package:arch/arch.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
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

const _kTeachersApiKey = "warehouse/teachercount";
const _kSchoolsApiKey = "warehouse/tableenrol";
const _kExamsApiKey = "warehouse/examsdistrictresults";
const _kSchoolAccreditationsByStateApiKey =
    "warehouse/accreditations/table?byState";
const _kSchoolAccreditationsByStandardApiKey =
    "warehouse/accreditations/table?byStandard";
const _kLookupsApiKey = "lookups/collection/core";
const _kIndividualSchoolEnrollApiKey = "warehouse/enrol/school/";
const _kIndividualDistrictEnrollApiKey = "warehouse/enrol/district/";
const _kIndividualNationEnrollApiKey = "warehouse/enrol/electoraten";

typedef _HandledApiCallable<T> = FutureOr<T> Function(
    String, Options); // url, headers
typedef _ThrowableHandler = void Function(String, Object);

class RemoteDataSourceImpl implements RemoteDataSource {
  static const platform = const MethodChannel('com.pacific_emis.opendata/api');

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
    )
    ..transformer = FlutterTransformer();

  RemoteDataSourceImpl(GlobalSettings settings) : _settings = settings;

  void _handleErrors(String url, Object throwable) {
    if (throwable is DioError) {
      final response = throwable.response;
      switch (response.statusCode) {
        case 401:
          throw UnauthorizedRemoteException(
            url: url,
            message: response.statusMessage,
            code: response.statusCode,
          );
        case 304:
          throw NoNewDataRemoteException(url: url);
      }
    }
    throw UnknownRemoteException(url: url);
  }

  Future<T> _withHandlers<T>({
    @required String callPath,
    List<_ThrowableHandler> additionalHandlers,
    @required _HandledApiCallable<T> callable,
  }) async {
    final emis = await _settings.currentEmis;
    final requestUrl = '${emis.baseUrl}$callPath';
    final existingEtag = await _settings.getEtag(requestUrl);
    var headers = {
      'Accept-Encoding': 'gzip, deflate',
    };
    if (existingEtag != null) {
      headers['If-None-Match'] = existingEtag;
    }
    final options = Options(headers: headers);
    try {
      return await callable.call(requestUrl, options);
    } catch (e) {
      if (additionalHandlers != null) {
        for (var handler in additionalHandlers) {
          handler.call(requestUrl, e);
        }
      }
      _handleErrors(requestUrl, e);
      rethrow;
    }
  }

//  Future<String> _get({
//    @required String path,
//    String restApiParameter,
//    Map<String, String> queryParameters,
//    bool forced = false,
//  }) async {
//    final emis = await _settings.currentEmis;
//    final requestUrl = '${emis.baseUrl}$path${restApiParameter ?? ''}';
//    final existingEtag = forced ? null : await _settings.getEtag(requestUrl);
//    var headers = {
//      'Accept-Encoding': 'gzip, deflate',
//    };
//    if (existingEtag != null) {
//      headers['If-None-Match'] = existingEtag;
//    }
//    final options = Options(headers: headers);
//    Response<String> response;
//
//    try {
//      response = await _dio.get(
//        requestUrl,
//        options: options,
//        queryParameters: queryParameters,
//      );
//    } on DioError catch (error) {
//      print(error.message);
//      // https://github.com/flutter/flutter/issues/41573
//      if (error.message.contains('full header') ||
//          error.message.contains('HttpException: ,')) {
//        response = await _fallbackApiGetCall(requestUrl, existingEtag);
//      } else {
//        throw NoInternetException();
//      }
//    }
//
//    if (response.statusCode == 304) {
//      throw NoNewDataRemoteException(url: requestUrl);
//    }
//
//    final responseEtag = response.headers.value("ETag");
//    if (responseEtag != null && responseEtag != existingEtag) {
//      _settings.setEtag(requestUrl, responseEtag);
//    }
//
//    return response.data;
//  }
//
//  Future<Response<String>> _fallbackApiGetCall(String url, String eTag) async {
//    try {
//      final Map result = await platform.invokeMethod('apiGet', {
//        'url': url,
//        'eTag': eTag,
//      });
//      print(result);
//      final response = Response<String>(
//        headers: Headers.fromMap({
//          'ETag': [result['eTag']]
//        }),
//        statusCode: result['code'],
//        data: result['body'],
//      );
//      return response;
//    } catch (error) {
//      print(error);
//      throw UnknownRemoteException(url: url);
//    }
//  }

  @override
  Future<List<Teacher>> fetchTeachers() async {
    return _withHandlers(
      callPath: _kTeachersApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<Teacher>>(
            _parseTeachersList, response.data);
      },
    );
  }

  static List<Teacher> _parseTeachersList(List<dynamic> json) {
    return json.map((it) => Teacher.fromJson(it)).toList();
  }

  @override
  Future<List<School>> fetchSchools() async {
    return _withHandlers(
      callPath: _kSchoolsApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<School>>(
            _parseSchoolsList, response.data);
      },
    );
  }

  static List<School> _parseSchoolsList(List<dynamic> json) {
    return json.map((it) => School.fromJson(it)).toList();
  }

  @override
  Future<List<Exam>> fetchExams() async {
    return _withHandlers(
      callPath: _kExamsApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<Exam>>(
            _parseExamsList, response.data);
      },
    );
  }

  static List<Exam> _parseExamsList(List<dynamic> json) {
    return json.map((it) => Exam.fromJson(it)).toList();
  }

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async {
    final byStandardData = await _withHandlers(
      callPath: _kSchoolAccreditationsByStandardApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return response.data;
      },
    );
    final byDistrictData = await _withHandlers(
      callPath: _kSchoolAccreditationsByStateApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return response.data;
      },
    );
    return compute(
        _parseAccreditationData,
        AccreditationChunkJsonParts(
          byDistrictJson: byDistrictData,
          byStandardJson: byStandardData,
        ));
  }

  static AccreditationChunk _parseAccreditationData(
    AccreditationChunkJsonParts parts,
  ) {
    return AccreditationChunk(
      byDistrict: parts.byDistrictJson
          .map((it) => DistrictAccreditation.fromJson(it))
          .toList(),
      byStandard: parts.byStandardJson
          .map((it) => StandardAccreditation.fromJson(it))
          .toList(),
    );
  }

  @override
  Future<Lookups> fetchLookupsModel() async {
    return _withHandlers(
      callPath: _kLookupsApiKey,
      callable: (url, options) async {
        final response = await _dio.get(url, options: options);
        _settings.setEtag(url, response.eTag);
        return compute<Map<String, dynamic>, Lookups>(
            _parseLookups, response.data);
      },
    );
  }

  static Lookups _parseLookups(Map<String, dynamic> json) {
    return Lookups.fromJson(json);
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(
    String schoolId,
  ) async {
    return _withHandlers(
      callPath: _kIndividualSchoolEnrollApiKey + '/$schoolId',
      callable: (url, options) async {
        final response = await _dio.get(
          url,
          options: options,
          queryParameters: {
            'report': true,
          },
        );
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<SchoolEnroll>>(
            _parseSchoolEnrollList, response.data);
      },
    );
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(
    String districtCode,
  ) async {
    return _withHandlers(
      callPath: _kIndividualDistrictEnrollApiKey + '/$districtCode',
      callable: (url, options) async {
        final response = await _dio.get(
          url,
          options: options,
          queryParameters: {
            'report': true,
          },
        );
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<SchoolEnroll>>(
            _parseSchoolEnrollList, response.data);
      },
    );
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualNationEnroll() async {
    return _withHandlers(
      callPath: _kIndividualNationEnrollApiKey,
      callable: (url, options) async {
        final response = await _dio.get(
          url,
          options: options,
          queryParameters: {
            'report': true,
          },
        );
        _settings.setEtag(url, response.eTag);
        return compute<List<dynamic>, List<SchoolEnroll>>(
            _parseSchoolEnrollList, response.data);
      },
    );
  }

  static List<SchoolEnroll> _parseSchoolEnrollList(List<dynamic> json) {
    return json.map((it) => SchoolEnroll.fromJson(it)).toList();
  }

  @override
  Future<String> fetchAccessToken() {
    // TODO: implement fetchAccessToken
    throw UnimplementedError();
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

extension EtaggedResponse on Response {
  String get eTag => this.headers.value('ETag');
}
