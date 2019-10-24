import 'dart:io';
import 'dart:convert';
import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import 'package:pacific_dashboards/src/resources/FileProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileProviderImpl extends FileProvider {
  static const _kSchoolsKey = "schools";
  static const _kTeachersKey = "teachers";
  static const _kExamsKey = "exams";
  static const _kSchoolAccreditationKey = "accreditations";
  static const _kLookupsKey = "lookups";
  static const _kMicronesiaPath = "FSOM";
  static const _kMarshalsPath = "MI";
  static const _kCountryKey = "country";
  static const _kDefaultCountry = "Federated States of Micronesia";

  SharedPreferences _sharedPreferences;
  String get basePath {
    var basePath =
        (_sharedPreferences.getString(_kCountryKey) ?? _kDefaultCountry) ==
                _kDefaultCountry
            ? _kMicronesiaPath
            : _kMarshalsPath;
    return basePath;
  }

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
    } catch (e) {
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

  Future<String> loadFileData(String key) async {
    if (!await _isTimePassed(basePath + key)) {
      String result = await _readFile(basePath + key);
      return result;
    }
    return null;
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel() async {
    return SchoolsModel.fromJson(
        json.decode(await _readFile(basePath + _kSchoolsKey)));
  }

  @override
  Future<TeachersModel> fetchTeachersModel() async {
    return TeachersModel.fromJson(
        json.decode(await _readFile(basePath + _kTeachersKey)));
  }

  @override
  Future<ExamsModel> fetchExamsModel() async {
    return ExamsModel.fromJson(
        json.decode(await _readFile(basePath + _kExamsKey)));
  }

  @override
  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk() async {
    Map<dynamic, dynamic> parsedJson =
        json.decode(await _readFile(basePath + _kSchoolAccreditationKey));
    return SchoolAccreditationsChunk.fromJson(parsedJson);
  }

  @override
  Future<LookupsModel> fetchLookupsModel() async {
    return LookupsModel.fromJson(
        jsonDecode(await _readFile(basePath + _kLookupsKey)));
  }

  @override
  Future<SchoolsModel> fetchValidSchoolsModel() async {
    try {
      if (!await _isTimePassed(basePath + _kSchoolsKey)) {
        return fetchSchoolsModel();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TeachersModel> fetchValidTeachersModel() async {
    try {
      if (!await _isTimePassed(basePath + _kTeachersKey)) {
        return fetchTeachersModel();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ExamsModel> fetchValidExamsModel() async {
    try {
      if (!await _isTimePassed(basePath + _kExamsKey)) {
        return fetchExamsModel();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SchoolAccreditationsChunk> fetchValidSchoolAccreditationsChunk() async {
    try {
      if (!await _isTimePassed(basePath + _kSchoolAccreditationKey)) {
        return fetchSchoolAccreditationsChunk();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LookupsModel> fetchValidLookupsModel() async {
    try {
      if (!await _isTimePassed(basePath + _kLookupsKey)) {
        return fetchLookupsModel();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveSchoolsModel(SchoolsModel model) async {
    return await _writeFile(basePath + _kSchoolsKey, model) != null;
  }

  @override
  Future<bool> saveTeachersModel(TeachersModel model) async {
    return await _writeFile(basePath + _kTeachersKey, model) != null;
  }

  @override
  Future<bool> saveExamsModel(ExamsModel model) async {
    return await _writeFile(basePath + _kExamsKey, model) != null;
  }

  @override
  Future<bool> saveSchoolAccreditaitonsChunk(
      SchoolAccreditationsChunk chunk) async {
    return await _writeFile(basePath + _kSchoolAccreditationKey, chunk) !=
        null;
  }

  @override
  Future<bool> saveLookupsModel(LookupsModel model) async {
    return await _writeFile(basePath + _kLookupsKey, model) != null;
  }
}
