import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arch/arch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source.dart';
import 'package:pacific_dashboards/data/data_source/remote/rest_client.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emises_config.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school/schools_chunk.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:pacific_dashboards/utils/xml_to_json.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../models/exam/exam_separated.dart';

const _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm/api/";
const _kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis/api/";
const _kKiribatiUrl = "https://data.moe.gov.ki/kemis/api/";

typedef _HandledApiCallable<T> = FutureOr<T> Function(RestClient);
typedef _FallbackHandler<T> = Future<T> Function(Object);

class RemoteDataSourceImpl implements RemoteDataSource {
  static const platform = const MethodChannel('com.pacific_emis.opendata/api');

  final GlobalSettings _settings;
  final EmisesConfig _emises;
  Dio _dio;
  RestClient _fedemisClient;
  RestClient _miemisClient;
  RestClient _kemisClient;

  RemoteDataSourceImpl(GlobalSettings settings, EmisesConfig emises)
      : _settings = settings,
        _emises = emises {
    _dio = Dio(BaseOptions(
        validateStatus: (int status) {
          return status >= 200 && status < 300 || status == 304;
        },
      connectTimeout: Duration(seconds: 150).inMilliseconds,
      receiveTimeout: Duration(minutes: 300).inMilliseconds,
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
              if (response.headers[Headers.contentTypeHeader]
                  .contains("application/xml")) {
                response.data =
                    XmlToJson.decodeXmlResponseIntoJson(response.data);
              }
              return response;
            }
          },
          onError: (error) {
            print(error);
            return error;
          },
        ),
        // if (kDebugMode)
        //   PrettyDioLogger(
        //     requestHeader: true,
        //     requestBody: true,
        //     responseBody: true,
        //     responseHeader: true,
        //     error: true,
        //     compact: true,
        //     maxWidth: 100,
        //   ),
      ])
      ..transformer = FlutterTransformer();

    _fedemisClient = RestClient(_dio,
        baseUrl: emises.getEmisConfigFor(Emis.fedemis).emisUrl);
    _miemisClient =
        RestClient(_dio, baseUrl: emises.getEmisConfigFor(Emis.miemis).emisUrl);
    _kemisClient =
        RestClient(_dio, baseUrl: emises.getEmisConfigFor(Emis.kemis).emisUrl);

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<void> _handleErrors(DioError error) async {
    final response = error.response;
    if (response == null || response.statusCode == null) {
      if (error.message.contains('closed') ||
          error.message.contains('abort') ||
          error.message.contains('no address')) {
        throw NoInternetException();
      } else {
        await checkConnection();
      }

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
    List<_FallbackHandler> fallbackHandlers,
  }) async {
    try {
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
        if (fallbackHandlers != null) {
          for (final handler in fallbackHandlers) {
            final fallbackResult = await handler.call(e);
            if (fallbackResult != null) {
              return fallbackResult;
            }
          }
        }
        rethrow;
      }
    } catch (e) {
      if (e is DioError) {
        await _handleErrors(e);
      }
      rethrow;
    }
  }

  Future<Response<String>> _fallbackApiGetCall(String url, String eTag) async {
    try {
      final result = await platform.invokeMethod<Map>('apiGet', {
        'url': url,
        'eTag': eTag,
      });
      final response = Response<String>(
        headers: Headers.fromMap({
          'ETag': [result['eTag']]
        }),
        statusCode: result['code'],
        data: result['body'],
      );
      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      debugPrint(error);
      throw UnknownRemoteException(url: url);
    }
  }

  Future<T> _fallbackToNative<T>(
    Object throwable,
    String urlCall,
    Future<T> Function(String json) parseJson,
  ) async {
    if (!(throwable is DioError &&
        throwable.message.contains('HttpException: '))) {
      return null;
    }
    await checkConnection();
    final emis = await _settings.currentEmis;
    final url = '${emis.baseUrl}$urlCall';
    try {
      final savedETag = await _settings.getEtag(url);
      final nativeResponse = await _fallbackApiGetCall(
        url,
        savedETag,
      );
      if (nativeResponse.statusCode == 304) {
        throw NoNewDataRemoteException(url: url);
      }
      final eTag = nativeResponse.eTag;
      await _settings.setEtag(url, eTag);

      final responseJson = nativeResponse.data;
      debugPrint('Fallback response : $responseJson');
      final parsed = await parseJson(responseJson);
      return parsed;
    } on NoNewDataRemoteException {
      debugPrint('Fallback 304');
      rethrow;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // Ignore native errors since it is a fallback
      debugPrint('Fallback error ${e.toString()}');
      return null;
    }
  }

  Future<void> checkConnection() async {
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
        _emises.getEmisConfigFor(Emis.fedemis).emisUser,
        _emises.getEmisConfigFor(Emis.fedemis).emisPassword,
      ),
    );
    return response.accessToken;
  }

  @override
  Future<List<ExamSeparated>> fetchExamsSeparated() {
    return _withHandlers(
          (client) => client.getExamsSeparated(), //client.getExamsSeparated(),
      fallbackHandlers: [
            (e) => _fallbackToNative(
          e,
          'warehouse/exams/table',
              (json) => compute<String, List<ExamSeparated>>(
                _parseExamsSeparatedList,
                json,
          ),
        ),
      ],
    );
  }

  @override
  Future<IndicatorsContainer> fetchIndicators(String districtCode) {
    return _withHandlers(
      (client) => client.getIndicators(districtCode),
    );
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
    return _withHandlers((client) => client.getLookups(), fallbackHandlers: [
      (e) => _fallbackToNative(
            e,
            'lookups/collection/core',
            (json) => compute<String, Lookups>(
              _parseLookups,
              json,
            ),
          ),
    ]);
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
  Future<SchoolsChunk> fetchSchools() async {
    final byState = await _withHandlers(
        (client) => client.getSchools(),
        fallbackHandlers: [
          (e) => _fallbackToNative(
                e,
                'warehouse/tableenrol',
                (json) => compute<String, List<School>>(
                  _parseSchoolList,
                  json,
                ),
              ),
        ],
      );
    return SchoolsChunk(byState: byState, byAuthority: byState);
  }

  @override
  Future<List<School>> fetchSchoolsAuthority() {
    return _withHandlers(
          (client) => client.getSchoolsAuthority(),
      fallbackHandlers: [
            (e) => _fallbackToNative(
          e,
          'warehouse/tableenrol',
              (json) => compute<String, List<School>>(
            _parseSchoolList,
            json,
          ),
        ),
      ],
    );
  }

  @override
  Future<List<Teacher>> fetchTeachers() {
    return _withHandlers(
      (client) => client.getTeachers(),
      fallbackHandlers: [
        (e) => _fallbackToNative(
              e,
              'warehouse/teachers?report',
              (json) => compute<String, List<Teacher>>(
                _parseTeachersList,
                json,
              ),
            ),
      ],
    );
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

List<School> _parseSchoolList(String json) {
  final List<dynamic> data = jsonDecode(json);
  return data.map((it) => School.fromJson(it as Map<String, dynamic>)).toList();
}

List<Teacher> _parseTeachersList(String json) {
  final List<dynamic> data = jsonDecode(json);
  return data
      .map((it) => Teacher.fromJson(it as Map<String, dynamic>))
      .toList();
}

List<ExamSeparated> _parseExamsSeparatedList(String json) {
  final List<dynamic> data = jsonDecode(json);
  return data.map((it) =>
      ExamSeparated.fromJson(it as Map<String, dynamic>)).toList();
}

Lookups _parseLookups(String json) {
  return Lookups.fromJson(jsonDecode(json) as Map<String, dynamic>);
}
