import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' show Client;
import '../resources/FileProvider.dart';
import '../models/schools_model.dart';
import '../models/teachers_model.dart';
import 'dart:convert';

class FileProviderImpl extends FileProvider{

  static final Client _client = Client();
  static final _baseUrl = "https://fedemis.doe.fm";
  static final _schoolsId = "schools";
  static final _teachersId = "teachers";
  SharedPreferences _sharedPreferences;

  FileProviderImpl(SharedPreferences sharedPreferences){
    _sharedPreferences = sharedPreferences;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.txt');
  }

  Future<String> _readFile(String key) async {
    try {
      print('loadFileData');
      final file = await _localFile(key);

      String contents = await file.readAsString();
      print(contents);
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> _writeFile(String key, String str) async {
    final file = await _localFile(key);
    _saveTime(key);
    return file.writeAsString(str);
  }

  Future<bool> _timePassed(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(key + 'time') ?? new DateTime(0).toString();
    DateTime oldDate = DateTime.parse(timeStr);
    final todayDate = DateTime.now();
    final timePass = todayDate.difference(oldDate);
    if (timePass.inHours > 12 || timePass.inMinutes < -5) {
      return true;
    } else{
      return false;
    }
  }

  Future<bool> _saveTime(String key) async {
    final todayDate = DateTime.now();
    return _sharedPreferences.setString(key + 'time', todayDate.toString());
  }

@override
  Future<String> loadFileData(String key) async {
    if (!await _timePassed(key)) {
      String result = await _readFile(key);
      return result;
    }

    try {
      final webResponse =
      await _client.get("$_baseUrl/api/warehouse/$key").timeout(
          const Duration(seconds: 20));
      print(webResponse.body.toString());

      if (webResponse.statusCode == 200) {
        await _writeFile(key, webResponse.body.toString());
        return webResponse.body.toString();
      } else {
        return await _readFile(key);
      }
    } catch (e) {
      print(e.toString());
      return await _readFile(key);
    }
  }

  @override
  Future<SchoolsModel> fetchSchoolsList() async {
    return SchoolsModel.fromJson(json.decode(await _readFile(_schoolsId)));
  }

  @override
  Future<TeachersModel> fetchTeachersList() async {
    return TeachersModel.fromJson(json.decode(await _readFile(_teachersId)));
  }

  @override
  Future<bool> saveSchoolsList(SchoolsModel model) async {
    await _writeFile(_schoolsId, "");
    return true;
  }

  @override
  Future<bool> saveTeachersList(TeachersModel model) async {
    await _writeFile(_teachersId, json.encode(model.toJson()));
    return true;
  }

}