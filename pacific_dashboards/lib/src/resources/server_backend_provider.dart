import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'package:pacific_dashboards/src/models/schools_model.dart';
import 'package:pacific_dashboards/src/utils/Exceptions/data_not_loaded_exception.dart';
import '../models/teachers_model.dart';
import 'backend_provider.dart';

class ServerBackendProvider implements BackendProvider {
  static const String BASE_URL = "https://fedemis.doe.fm";
  static const String TEACHERS_API_KEY = "teachercount";
  static const String SCHOOLS_API_KEY = "examsdistrictresults";

  Client client = Client();

  Future<TeachersModel> fetchTeachersList() async {
    final webResponse =
    await client.get("$BASE_URL/api/warehouse/$TEACHERS_API_KEY");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return TeachersModel.fromJson(json.decode(webResponse.body));
    } else {
      throw DataNotLoadedException(TEACHERS_API_KEY);
    }
  }

  Future<SchoolsModel> fetchSchoolsList() async {
    final webResponse =
    await client.get("$BASE_URL/api/warehouse/$SCHOOLS_API_KEY");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return SchoolsModel.fromJson(json.decode(webResponse.body));
    } else {
      throw DataNotLoadedException(SCHOOLS_API_KEY);
    }
  }
}
