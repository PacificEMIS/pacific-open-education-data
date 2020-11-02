import 'dart:async';

import 'package:arch/arch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source.dart';
import 'package:pacific_dashboards/data/data_source/remote/rest_client.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/emis.dart';
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
import 'package:pacific_dashboards/utils/exceptions.dart';

const _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm/api/";
const _kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis/api/";
const _kKiribatiUrl = "https://data.moe.gov.ki/kemis/api/";

typedef _HandledApiCallable<T> = FutureOr<T> Function(RestClient);
typedef _ThrowableHandler = void Function(Object);

class RemoteDataSourceImpl implements RemoteDataSource {
  static const platform = const MethodChannel('com.pacific_emis.opendata/api');

  final GlobalSettings _settings;

  Dio _dio;
  RestClient _fedemisClient;
  RestClient _miemisClient;
  RestClient _kemisClient;

  RemoteDataSourceImpl(GlobalSettings settings) : _settings = settings {
    _dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 10).inMilliseconds,
      receiveTimeout: Duration(minutes: 5).inMilliseconds,
      headers: {
        'Accept-Encoding': 'gzip, deflate',
      },
    ))
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (options) async {
            final savedETag = await _settings.getEtag(options.url);
            if (savedETag != null && savedETag.isNotEmpty) {
              options.headers['If-None-Match'] = savedETag;
            }
            return options;
          },
          onResponse: (response) {
            if (response.statusCode == 304) {
              return DioError(
                request: response.request,
                response: response,
                type: DioErrorType.RESPONSE,
                error: NoNewDataRemoteException(url: response.requestUrl),
              );
            } else {
              final eTag = response.eTag;
              _settings.setEtag(response.requestUrl, eTag);
              return response;
            }
          },
          onError: (error) {
            print(error);
            return error;
          },
        ),
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      ])
      ..transformer = FlutterTransformer();

    _fedemisClient = RestClient(_dio, baseUrl: _kFederalStatesOfMicronesiaUrl);
    _miemisClient = RestClient(_dio, baseUrl: _kMarshalIslandsUrl);
    _kemisClient = RestClient(_dio, baseUrl: _kKiribatiUrl);
  }

  void _handleErrors(DioError error) {
    final response = error.response;
    if (response == null || response.statusCode == null) {
      if (error.message.contains('Connection closed') ||
          error.message.contains('abort'))
        throw NoInternetException();
      else if (error.message == '') checkConnection();

      throw UnknownRemoteException(url: '');
    }
    final code = response.statusCode;
    final url = response.requestUrl;

    switch (code) {
      case 401:
        throw UnauthorizedRemoteException(
          url: response.requestUrl,
          message: response.statusMessage,
          code: code,
        );
      case 304:
        throw NoNewDataRemoteException(url: url);
      default:
        throw UnknownRemoteException(url: url);
    }
  }

  Future<T> _withHandlers<T>(
    _HandledApiCallable<T> callable, {
    List<_ThrowableHandler> additionalHandlers,
  }) async {
    try {
      await checkConnection();

      final emis = await _settings.currentEmis;
      RestClient client;
      switch (emis) {
        case Emis.miemis:
          client = _miemisClient;
          break;
        case Emis.fedemis:
          client = _fedemisClient;
          break;
        case Emis.kemis:
          client = _kemisClient;
          break;
      }
      return await callable.call(client);
    } catch (e) {
      if (additionalHandlers != null) {
        for (var handler in additionalHandlers) {
          handler.call(e);
        }
      }
      if (e is DioError) {
        _handleErrors(e);
      }
      rethrow;
    }
  }

  Future checkConnection() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      throw NoInternetException();
    }
  }

  @override
  Future<String> fetchAccessToken() async {
    final response = await _withHandlers(
      (client) => client.getToken(
        'password',
        _settings.getApiUserName(),
        _settings.getApiPassword(),
      ),
    );
    return response.accessToken;
  }

  @override
  Future<List<Exam>> fetchExams() {
    return _withHandlers((client) => client.getExams());
  }

  @override
  Future<List<Budget>> fetchBudgets() {
    return _withHandlers((client) => client.getBudgets());
  }

  @override
  Future<List<SpecialEducation>> fetchSpecialEducation() {
    return _withHandlers((client) => client.getSpecialEducation());
  }

  @override
  Future<WashChunk> fetchWashChunk() async {
    final totalData = await _withHandlers(
      (client) => client.getWashGlobalData(),
    );
    final toiletsData = await _withHandlers(
      (client) => client.getWashToilets(),
    );
    final waterData = await _withHandlers((client) => client.getWashWater());
    final questionData = await _withHandlers(
      (client) => client.getWashQuestions(),
    );
    return WashChunk(
      total: totalData,
      toilets: toiletsData,
      water: waterData,
      questions: questionData,
    );
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualDistrictEnroll(
    String districtCode,
  ) {
    return _withHandlers(
        (client) => client.getIndividualDistrictEnroll(districtCode));
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualNationEnroll() {
    return _withHandlers((client) => client.getIndividualNationEnroll());
  }

  @override
  Future<List<SchoolEnroll>> fetchIndividualSchoolEnroll(String schoolId) {
    return _withHandlers(
        (client) => client.getIndividualSchoolEnroll(schoolId));
  }

  @override
  Future<Lookups> fetchLookupsModel() {
    return _withHandlers((client) => client.getLookups());
  }

  @override
  Future<FinancialLookups> fetchFinancialLookupsModel() {
    return _withHandlers((client) => client.getFinanceLookups());
  }

  @override
  Future<AccreditationChunk> fetchSchoolAccreditationsChunk() async {
    final districtData = await _withHandlers(
        (client) => client.getSchoolAccreditationsByDistrict());
    final standardData = await _withHandlers(
        (client) => client.getSchoolAccreditationsByStandard());
    final nationalData = await _withHandlers(
        (client) => client.getSchoolAccreditationsByNation());
    return AccreditationChunk(
      byDistrict: districtData,
      byStandard: standardData,
      byNational: nationalData,
    );
  }

  @override
  Future<List<School>> fetchSchools() {
    return _withHandlers((client) => client.getSchools());
  }

  @override
  Future<List<Teacher>> fetchTeachers() {
    return _withHandlers((client) => client.getTeachers());
  }

  @override
  Future<List<ShortSchool>> fetchSchoolsList(String accessToken) async {
    final response = await _withHandlers(
      (client) => client.getSchoolsList('Bearer $accessToken', 0),
    );
    return response.schools;
  }

  @override
  Future<List<SchoolFlow>> fetchSchoolFlow(String schoolId) {
    return _withHandlers((client) => client.getSchoolFlow(schoolId));
  }

  @override
  Future<List<SchoolExamReport>> fetchSchoolExamReports(String schoolId) {
    return _withHandlers((client) => client.getSchoolExamReports(schoolId));
  }

  @override
  Future<IndividualSchool> fetchIndividualSchool(
    String accessToken,
    String schoolId,
  ) async {
    final response = await _withHandlers(
      (client) => client.getIndividualSchool(
        'Bearer $accessToken',
        schoolId,
      ),
    );
    return response.school;
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

extension RequestOptionsExt on RequestOptions {
  String get url => this.uri.toString();
}

extension ResponseExt on Response {
  String get eTag => this.headers.value('ETag');

  String get requestUrl => this.request.url;
}
