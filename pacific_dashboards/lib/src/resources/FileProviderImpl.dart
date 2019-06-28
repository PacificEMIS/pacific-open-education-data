import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/FileProvider.dart';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';

class FileProviderImpl extends FileProvider {
  static const _KEY_SCHOOLS = "schools";
  static const _KEY_TEACHERS = "teachers";

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
      print(contents);
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> _writeFile(String key, String str) async {
    final file = await _createFile(key);
    _saveTime(key);
    return file.writeAsString(str);
  }

  Future<bool> _saveTime(String key) async {
    final todayDate = DateTime.now();
    return _sharedPreferences.setString(key + 'time', todayDate.toString());
  }

  Future<bool> _timePassed(String key) async {
    try {
      final timeStr = _sharedPreferences.getString(key + 'time') ??
          new DateTime(0).toString();
      DateTime oldDate = DateTime.parse(timeStr);
      final todayDate = DateTime.now();
      final timePass = todayDate.difference(oldDate);
      if (timePass.inHours > 12 || timePass.inMinutes < -5) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  @override
  Future<String> loadFileData(String key) async {
    if (!await _timePassed(key)) {
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
  Future<SchoolsModel> fetchLastSchoolsModel() async {
    try {
      if (!await _timePassed(_KEY_SCHOOLS)) {
        return SchoolsModel.fromJson(json.decode(await _readFile(_KEY_SCHOOLS)));
      }
      return null;
    } catch(e) {
      return null;
    }
  }

  @override
  Future<TeachersModel> fetchLastTeachersModel() async {
    try {
      if (!await _timePassed(_KEY_TEACHERS)) {
        return TeachersModel.fromJson(json.decode(await _readFile(_KEY_TEACHERS)));
      }
      return null;
    } catch(e) {
      return null;
    }
  }

  @override
  Future<bool> saveSchoolsModel(SchoolsModel model) async {
    await _writeFile(_KEY_SCHOOLS, json.encode(model.toJson()));
    return true;
  }

  @override
  Future<bool> saveTeachersModel(TeachersModel model) async {
    await _writeFile(_KEY_TEACHERS, json.encode(model.toJson()));
    return true;
  }
}
