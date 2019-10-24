import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import 'package:pacific_dashboards/src/utils/Exceptions/DataNotLoadedException.dart';
import 'package:pacific_dashboards/src/resources/Provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerBackendProvider implements Provider {
  static String _kBaseUrl = "https://fedemis.doe.fm";
  static const String _kFederalStatesOfMicronesiaUrl = "https://fedemis.doe.fm";
  static const String kMarshalIslandsUrl = "http://data.pss.edu.mh/miemis";
  static const String kTeachersApiKey = "warehouse/teachercount";
  static const String kSchoolsApiKey = "warehouse/tableenrol";
  static const String kExamsApiKey = "warehouse/examsdistrictresults";
  static const String kSchoolAccreditationsByStateApiKey =
      "warehouse/accreditations/table?byState";
  static const String kSchoolAccreditationsByStandardApiKey =
      "warehouse/accreditations/table?byStandard";
  static const String kLookupsApiKey = "lookups/collection/core";
  static const String _kCountryKey = "country";
  static const String _kDefaultCountry = "Federated States of Micronesia";

  SharedPreferences _sharedPreferences;

  ServerBackendProvider(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  Client _client = Client();

  Future<String> _request(String path) async {
    _kBaseUrl =
        (_sharedPreferences.getString(_kCountryKey) ?? _kDefaultCountry) ==
                _kDefaultCountry
            ? _kFederalStatesOfMicronesiaUrl
            : kMarshalIslandsUrl;

    final webResponse = await _client
        .get("$_kBaseUrl/api/$path")
        .timeout(const Duration(minutes: 1));
    debugPrint(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return webResponse.body;
    } else {
      throw DataNotLoadedException(path);
    }
  }

  @override
  Future<TeachersModel> fetchTeachersModel() async {
    final responseData = await _request(kTeachersApiKey);
    return TeachersModel.fromJson(json.decode(responseData.toString()));
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel() async {
    final responseData = await _request(kSchoolsApiKey);
    return SchoolsModel.fromJson(json.decode(responseData.toString()));
  }

  @override
  Future<ExamsModel> fetchExamsModel() async {
    final responseData = await _request(kExamsApiKey);
    return ExamsModel.fromJson(json.decode(responseData.toString()));
  }

  @override
  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk() async {
    final responseData = await _request(kSchoolAccreditationsByStandardApiKey);
    final testData = await _request(kSchoolAccreditationsByStateApiKey);
    var modelByState =
        SchoolAccreditationsModel.fromJson(json.decode(testData.toString()));
    var modelByStandard = SchoolAccreditationsModel.fromJson(
        json.decode(responseData.toString()));
    return SchoolAccreditationsChunk(
        statesChunk: modelByState, standardsChunk: modelByStandard);
  }

  @override
  Future<LookupsModel> fetchLookupsModel() async {
    final responseData = await _request(kLookupsApiKey);
    return LookupsModel.fromJson(jsonDecode(responseData.toString()));
  }
}
