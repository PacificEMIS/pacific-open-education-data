import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'package:pacific_dashboards/src/config/constants.dart';
import 'package:pacific_dashboards/src/models/schools_model.dart';
import 'package:pacific_dashboards/src/utils/Exceptions/data_not_loaded_exception.dart';
import '../models/teachers_model.dart';

class ChartsApiProvider {
  Client client = Client();

  final _teachersApiKey = TeachersApiKey;
  final _baseUrl = BaseUrl;
  final _schoolsApiKey = SchoolsApiKey;

  Future<TeachersModel> fetchTeachersList() async {
    final webResponse =
        await client.get("$_baseUrl/api/warehouse/$_teachersApiKey");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return TeachersModel.fromJson(json.decode(webResponse.body));
    } else {
      throw DataNotLoadedException(_teachersApiKey);
    }
  }

  Future<SchoolsModel> fetchSchoolsList() async {
    final webResponse =
    await client.get("$_baseUrl/api/warehouse/$_schoolsApiKey");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return SchoolsModel.fromJson(json.decode(webResponse.body));
    } else {
      throw DataNotLoadedException(_schoolsApiKey);
    }
  }
}
