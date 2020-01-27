import 'dart:io';
import 'dart:convert';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/local/file_provider.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
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

  final SharedPreferences _sharedPreferences;
  final GlobalSettings _settings;

  FileProviderImpl(SharedPreferences sharedPreferences, GlobalSettings settings)
      : _sharedPreferences = sharedPreferences,
        _settings = settings;

  String get _basePath =>
      _settings.currentEmis == GlobalSettings.kDefaultEmis
          ? _kMicronesiaPath
          : _kMarshalsPath;

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
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<File> _writeFile(String key, dynamic model) async {
    try {
      final file = await _createFile(key);
      return file.writeAsString(jsonEncode(model.toJson()));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel() async {
    final cachedJson = await _readFile(_basePath + _kSchoolsKey);
    if (cachedJson == null) {
      return null;
    }
    return SchoolsModel.fromJson(json.decode(cachedJson));
  }

  @override
  Future<TeachersModel> fetchTeachersModel() async {
    if (_isTimePassed(_kTeachersKey)) {
      return null;
    }
    final cachedJson = await _readFile(_basePath + _kTeachersKey);
    if (cachedJson == null) {
      return null;
    }
    return TeachersModel.fromJson(json.decode(cachedJson));
  }

  @override
  Future<ExamsModel> fetchExamsModel() async {
    if (_isTimePassed(_kExamsKey)) {
      return null;
    }
    final cachedJson = await _readFile(_basePath + _kExamsKey);
    if (cachedJson == null) {
      return null;
    }
    return ExamsModel.fromJson(json.decode(cachedJson));
  }

  @override
  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk() async {
    final cachedJson = await _readFile(_basePath + _kSchoolAccreditationKey);
    if (cachedJson == null) {
      return null;
    }
    return SchoolAccreditationsChunk.fromJson(json.decode(cachedJson));
  }

  @override
  Future<LookupsModel> fetchLookupsModel() async {
    if (_isTimePassed(_kLookupsKey)) {
      return null;
    }
    final cachedJson = await _readFile(_basePath + _kLookupsKey);
    if (cachedJson == null) {
      return null;
    }
    return LookupsModel.fromJson(json.decode(cachedJson));
  }

  @override
  Future<bool> saveSchoolsModel(SchoolsModel model) async {
    return await _writeFile(_basePath + _kSchoolsKey, model) != null;
  }

  @override
  Future<bool> saveTeachersModel(TeachersModel model) async {
    await _saveTime(_kTeachersKey);
    return await _writeFile(_basePath + _kTeachersKey, model) != null;
  }

  @override
  Future<bool> saveExamsModel(ExamsModel model) async {
    await _saveTime(_kExamsKey);
    return await _writeFile(_basePath + _kExamsKey, model) != null;
  }

  @override
  Future<bool> saveSchoolAccreditaitonsChunk(
      SchoolAccreditationsChunk chunk) async {
    return await _writeFile(_basePath + _kSchoolAccreditationKey, chunk) !=
        null;
  }

  @override
  Future<bool> saveLookupsModel(LookupsModel model) async {
    await _saveTime(_kLookupsKey);
    return await _writeFile(_basePath + _kLookupsKey, model) != null;
  }

  // TODO: deprecated zone
  Future<bool> _saveTime(String key) async {
    final todayDate = DateTime.now();
    return _sharedPreferences.setString(key + 'time', todayDate.toString());
  }

  bool _isTimePassed(String key) {
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
}
