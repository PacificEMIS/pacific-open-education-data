import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/teachers_model.dart';

class ChartsApiProvider {
  Client client = Client();

  final _dataApiKey = 'teachercount';
  final _baseUrl = "https://fedemis.doe.fm";

  Future<TeachersModel> fetchTeachersList() async {
    final webResponse =
        await client.get("$_baseUrl/api/warehouse/$_dataApiKey");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return TeachersModel.fromJson(json.decode(webResponse.body));
    } else {
      throw Exception('Failed to load web data');
    }
  }
}
