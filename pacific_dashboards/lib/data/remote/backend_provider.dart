import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/global_settings.dart';
import 'package:pacific_dashboards/data/provider.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/school_accreditations_model.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

class ServerBackendProvider implements Provider {
  static const _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm";
  static const kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis";
  static const kTeachersApiKey = "warehouse/teachercount";
  static const kSchoolsApiKey = "warehouse/tableenrol";
  static const kExamsApiKey = "warehouse/examsdistrictresults";
  static const _kSchoolAccreditationsByStateApiKey =
      "warehouse/accreditations/table?byState";
  static const _kSchoolAccreditationsByStandardApiKey =
      "warehouse/accreditations/table?byStandard";
  static const _kLookupsApiKey = "lookups/collection/core";

  final GlobalSettings _settings;
  Dio _dio;

  ServerBackendProvider(GlobalSettings settings) : _settings = settings {
    _dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 10).inMilliseconds,
      receiveTimeout: Duration(minutes: 1).inMilliseconds,
    ))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<dynamic> _get({@required String path, bool forced = false}) async {
    final baseUrl = _settings.currentEmis == GlobalSettings.kDefaultEmis
        ? _kFederalStatesOfMicronesiaUrl
        : kMarshalIslandsUrl;

    final requestUrl = '$baseUrl/api/$path';
    final existingEtag = _settings.getEtag(requestUrl);
    final Options options =
        !forced ? Options(headers: {'If-None-Match': existingEtag}) : null;

    Response<dynamic> response;
    try {
      response = await _dio.get(requestUrl, options: options);
    } on DioError catch (_) {
      throw UnavailableRemoteException();
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
  Future<TeachersModel> fetchTeachersModel({bool force = false}) async {
    final responseData = await _get(
        path: kTeachersApiKey,
        forced: true); // TODO: deprecated. forced disables ETag
    return TeachersModel.fromJson(responseData);
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel({bool force = false}) async {
    final responseData = await _get(path: kSchoolsApiKey);
    return SchoolsModel.fromJson(responseData);
  }

  @override
  Future<ExamsModel> fetchExamsModel({bool force = false}) async {
    final responseData = await _get(
        path: kExamsApiKey,
        forced: true); // TODO: deprecated. forced disables ETag
    return ExamsModel.fromJson(responseData);
  }

  @override
  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk(
      {bool force = false}) async {
    final responseData =
        await _get(path: _kSchoolAccreditationsByStandardApiKey);
    final testData = await _get(path: _kSchoolAccreditationsByStateApiKey);
    var modelByState = SchoolAccreditationsModel.fromJson(testData);
    var modelByStandard = SchoolAccreditationsModel.fromJson(responseData);
    return SchoolAccreditationsChunk(
        statesChunk: modelByState, standardsChunk: modelByStandard);
  }

  @override
  Future<LookupsModel> fetchLookupsModel({bool force = false}) async {
    final responseData = await _get(
        path: _kLookupsApiKey,
        forced: true); // TODO: deprecated. forced disables ETag
    return LookupsModel.fromJson(responseData);
  }
}
