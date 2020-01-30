import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dio/adapter.dart';
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
import 'package:pacific_dashboards/models/serialized/serializers.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

const _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm";
const _kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis";
const _kKiribatiUrl = "https://data.moe.gov.ki/kemis";

class RemoteDataSourceImpl implements RemoteDataSource {
  static const platform =
      const MethodChannel('fm.doe.national.pacific_dashboards/api');

  static const _kTeachersApiKey = "warehouse/teachercount";
  static const _kSchoolsApiKey = "warehouse/tableenrol";
  static const _kExamsApiKey = "warehouse/examsdistrictresults";
  static const _kSchoolAccreditationsByStateApiKey =
      "warehouse/accreditations/table?byState";
  static const _kSchoolAccreditationsByStandardApiKey =
      "warehouse/accreditations/table?byStandard";
  static const _kLookupsApiKey = "lookups/collection/core";

  final GlobalSettings _settings;
  Dio _dio;

  RemoteDataSourceImpl(GlobalSettings settings) : _settings = settings {
    _dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 10).inMilliseconds,
      receiveTimeout: Duration(minutes: 1).inMilliseconds,
    ))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    (_dio.httpClientAdapter as DefaultHttpClientAdapter)?.onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        print("badCertificateCallback cert=$cert host=$host port=$port");
        return true;
      };
    };
  }

  Future<String> _get({@required String path, bool forced = false}) async {
    final emis = await _settings.currentEmis;
    final requestUrl = '${emis.baseUrl}/api/$path';
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
      response = await _dio.get(requestUrl, options: options);
    } on DioError catch (error) {
      print(error.message);
      // https://github.com/flutter/flutter/issues/41573
      if (error.message.contains('full header') ||
          error.message.contains('HttpException: ,')) {
        response = await _fallbackApiGetCall(requestUrl, existingEtag);
      } else {
        throw UnavailableRemoteException();
      }
    }

    if (response.statusCode == 304) {
      throw NoNewDataRemoteException();
    } else if (response.statusCode != 200) {
      throw ApiRemoteException(
        url: requestUrl,
        code: response.statusCode,
        message: response.data.toString(),
      );
    }

    final responseEtag = response.headers.value("ETag");
    if (responseEtag != null && responseEtag != existingEtag) {
      _settings.setEtag(requestUrl, responseEtag);
    }

    return response.data;
  }

  @override
  Future<BuiltList<Teacher>> fetchTeachers() async {
    final responseData = await _get(path: _kTeachersApiKey);
    final List<dynamic> data = json.decode(responseData);
    return data
        .map((item) => serializers.deserializeWith(Teacher.serializer, item))
        .toBuiltList();
  }

  @override
  Future<BuiltList<School>> fetchSchools() async {
    final responseData = await _get(path: _kSchoolsApiKey);
    final List<dynamic> data = json.decode(responseData);
    return data
        .map((item) => serializers.deserializeWith(School.serializer, item))
        .toBuiltList();
  }

  @override
  Future<BuiltList<Exam>> fetchExams() async {
    final responseData = await _get(path: _kExamsApiKey);
    final List<dynamic> data = json.decode(responseData);
    return data
        .map((item) => serializers.deserializeWith(Exam.serializer, item))
        .toBuiltList();
  }

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async {
    final List<dynamic> byStandardData =
        json.decode(await _get(path: _kSchoolAccreditationsByStandardApiKey));
    final List<dynamic> byDistrictData =
        json.decode(await _get(path: _kSchoolAccreditationsByStateApiKey));

    final modelByStandard = byStandardData.map((item) =>
        serializers.deserializeWith(StandardAccreditation.serializer, item));

    final modelByDistrict = byDistrictData.map((item) =>
        serializers.deserializeWith(DistrictAccreditation.serializer, item));

    return AccreditationChunk(
      (b) => b
        ..byStandard = ListBuilder<StandardAccreditation>(modelByStandard)
        ..byDistrict = ListBuilder<DistrictAccreditation>(modelByDistrict),
    );
  }

  @override
  Future<Lookups> fetchLookupsModel() async {
    final responseData = await _get(
        path: _kLookupsApiKey,
        forced: true); // TODO: deprecated. forced disables ETag
    return Lookups.fromJson(responseData);
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
      throw ApiRemoteException(url: url, code: 0, message: error.toString());
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
