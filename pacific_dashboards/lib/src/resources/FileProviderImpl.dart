import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/LookupsModel.dart';
import '../models/ExamsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/FileProvider.dart';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';

class FileProviderImpl extends FileProvider {
  static const _KEY_SCHOOLS = "schools";
  static const _KEY_TEACHERS = "teachers";
  static const _KEY_EXAMS = "exams";
  static const _KEY_LOOKUPS = "lookups";

  SharedPreferences _sharedPreferences;

  FileProviderImpl(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _createFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.txt');
  }

  Future<String> _readFile(String key) async {
    try {
      final file = await _createFile(key);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> _writeFile(String key, dynamic model) async {
    try {
      final file = await _createFile(key);
      _saveTime(key);
      return file.writeAsString(jsonEncode(model.toJson()));
    } catch (e, stack) {
      debugPrint(e.toString() + stack.toString());
      return null;
    }
  }

  Future<bool> _saveTime(String key) async {
    final todayDate = DateTime.now();
    return _sharedPreferences.setString(key + 'time', todayDate.toString());
  }

  Future<bool> _isTimePassed(String key) async {
    try {
      final timeStr = _sharedPreferences.getString(key + 'time') ??
          new DateTime(0).toString();
      DateTime oldDate = DateTime.parse(timeStr);
      final todayDate = DateTime.now();
      final timePass = todayDate.difference(oldDate);
      return timePass.inHours > 12 || timePass.inMinutes < -5;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<String> loadFileData(String key) async {
    if (!await _isTimePassed(key)) {
      String result = await _readFile(key);
      return result;
    }
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel() async {
    return SchoolsModel.fromJson(json.decode(await _readFile(_KEY_SCHOOLS)));
  }

  @override
  Future<TeachersModel> fetchTeachersModel() async {
    return TeachersModel.fromJson(json.decode(await _readFile(_KEY_TEACHERS)));
  }

  @override
  Future<ExamsModel> fetchExamsModel() async {
    return ExamsModel.fromJson(json.decode(await _readFile(_KEY_EXAMS)));
  }

  @override
  Future<LookupsModel> fetchLookupsModel() async {
    return LookupsModel.fromJson(jsonDecode(await _readFile(_KEY_LOOKUPS)));
  }

  @override
  Future<SchoolsModel> fetchValidSchoolsModel() async {
    try {
      if (!await _isTimePassed(_KEY_SCHOOLS)) {
        return fetchSchoolsModel();
      }
      return null;
    } catch (e, stack) {
      debugPrint(e.toString() + stack.toString());
      return null;
    }
  }

  @override
  Future<TeachersModel> fetchValidTeachersModel() async {
    try {
      if (!await _isTimePassed(_KEY_TEACHERS)) {
        return fetchTeachersModel();
      }
      return null;
    } catch (e, stack) {
      debugPrint(e.toString() + stack.toString());
      return null;
    }
  }

  @override
  Future<ExamsModel> fetchValidExamsModel() async {
    try {
      if (!await _isTimePassed(_KEY_EXAMS)) {
        return fetchExamsModel();
      }
      return null;
    } catch (e, stack) {
      debugPrint(e.toString() + stack.toString());
      return null;
    }
  }

  @override
  Future<LookupsModel> fetchValidLookupsModel() async {
    try {
      if (!await _isTimePassed(_KEY_LOOKUPS)) {
        return fetchLookupsModel();
      }
      return null;
    } catch (e, stack) {
      debugPrint(e.toString() + stack.toString());
      return null;
    }
  }

  @override
  Future<bool> saveSchoolsModel(SchoolsModel model) async {
    return await _writeFile(_KEY_SCHOOLS, model) != null;
  }

  @override
  Future<bool> saveTeachersModel(TeachersModel model) async {
    return await _writeFile(_KEY_TEACHERS, model) != null;
  }

  @override
  Future<bool> saveExamsModel(ExamsModel model) async {
    return await _writeFile(_KEY_EXAMS, model) != null;
  }

  @override
  Future<bool> saveLookupsModel(LookupsModel model) async {
    return await _writeFile(_KEY_LOOKUPS, model) != null;
  }
}
