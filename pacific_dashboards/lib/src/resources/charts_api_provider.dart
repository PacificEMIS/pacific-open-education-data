import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/teachers_model.dart';
import '../models/item_model.dart';

class ChartsApiProvider {
  Client client = Client();

  final _dataApiKey = '1t1rKe6xgnBYgfzg8hnNQuuP_tvOJkp81';
  final _baseUrl = "https://drive.google.com";

  Future<ItemModel> fetchChartsList() async {
    final webResponse =
        await client.get("$_baseUrl/uc?export=download&id=$_dataApiKey");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return ItemModel.fromJson(json.decode(webResponse.body));
    } else {
      throw Exception('Failed to load web data');
    }
  }

  Future<TeachersModel> fetchTeachersList() async {
    final webResponse =
        await client.get("https://fedemis.doe.fm/api/warehouse/teachercount");
    print(webResponse.body.toString());

    if (webResponse.statusCode == 200) {
      return TeachersModel.fromJson(json.decode(webResponse.body));
    } else {
      throw Exception('Failed to load web data');
    }
  }
}
