import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/schools_model.dart';
import '../utils/Exceptions/data_not_loaded_exception.dart';
import '../models/teachers_model.dart';

import 'backend_provider.dart';

class ServerBackendProvider implements BackendProvider {
  static const String BASE_URL = "https://fedemis.doe.fm";
  static const String TEACHERS_API_KEY = "teachercount";
  static const String SCHOOLS_API_KEY = "examsdistrictresults";

  Client client = Client();

  Future<String> request(String path) async {
    final webResponse = await client.get("$BASE_URL/api/warehouse/$path");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return webResponse.body;
    } else {
      throw DataNotLoadedException(path);
    }
  }

  Future<TeachersModel> fetchTeachersList() async {
    final responseData = await request(TEACHERS_API_KEY);

    return TeachersModel.fromJson(json.decode(responseData));
  }

  Future<SchoolsModel> fetchSchoolsList() async {
    final responseData = await request(SCHOOLS_API_KEY);

    return SchoolsModel.fromJson(json.decode(responseData));
  }
}
