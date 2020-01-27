import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/data_source/local/key_string_storage.dart';
import 'package:pacific_dashboards/data/data_source/local/model/lookup/hive_lookups.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

class LocalDataSourceImpl extends LocalDataSource {
  static const _kSchoolsKey = 'schools';
  static const _kTeachersKey = 'teachers';
  static const _kExamsKey = 'exams';
  static const _kSchoolAccreditationKey = 'accreditations';
  static const _kLookupsKey = 'lookups';
  static const _kMicronesiaPath = 'FSOM';
  static const _kMarshalsPath = 'MI';
  static const _kKiribatiPath = 'KI';

  final KeyStringStorage _stringStorage;
  final GlobalSettings _settings;

  LocalDataSourceImpl(this._stringStorage, this._settings);

  String get _basePath {
    switch (_settings.currentEmis) {
      case Emis.miemis:
        return _kMarshalsPath;
      case Emis.fedemis:
        return _kMicronesiaPath;
      case Emis.kemis:
        return _kKiribatiPath;
    }
    throw FallThroughError();
  }

  @override
  Future<SchoolsModel> fetchSchoolsModel() async {
//    final cachedJson = await _readFile(_basePath + _kSchoolsKey);
//    if (cachedJson == null) {
//      return null;
//    }
//    return SchoolsModel.fromJson(json.decode(cachedJson));
  return null;
  }

  @override
  Future<TeachersModel> fetchTeachersModel() async {
//    if (_isTimePassed(_kTeachersKey)) {
//      return null;
//    }
//    final cachedJson = await _readFile(_basePath + _kTeachersKey);
//    if (cachedJson == null) {
//      return null;
//    }
//    return TeachersModel.fromJson(json.decode(cachedJson));

    return null;
  }

  @override
  Future<ExamsModel> fetchExamsModel() async {
//    if (_isTimePassed(_kExamsKey)) {
//      return null;
//    }
//    final cachedJson = await _readFile(_basePath + _kExamsKey);
//    if (cachedJson == null) {
//      return null;
//    }
//    return ExamsModel.fromJson(json.decode(cachedJson));

    return null;
  }

  @override
  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk() async {
//    final cachedJson = await _readFile(_basePath + _kSchoolAccreditationKey);
//    if (cachedJson == null) {
//      return null;
//    }
//    return SchoolAccreditationsChunk.fromJson(json.decode(cachedJson));

    return null;
  }

  @override
  Future<Lookups> fetchLookupsModel() async {
    final Box<HiveLookups> box = await Hive.openBox(_kLookupsKey);
    final storedLookups = box.get(0);
    return storedLookups.toLookups();
  }

  @override
  Future<void> saveSchoolsModel(SchoolsModel model) async {
//    return await _writeFile(_basePath + _kSchoolsKey, model) != null;
  }

  @override
  Future<void> saveTeachersModel(TeachersModel model) async {
//    await _saveTime(_kTeachersKey);
//    return await _writeFile(_basePath + _kTeachersKey, model) != null;
  }

  @override
  Future<void> saveExamsModel(ExamsModel model) async {
//    await _saveTime(_kExamsKey);
//    return await _writeFile(_basePath + _kExamsKey, model) != null;
  }

  @override
  Future<void> saveSchoolAccreditationsChunk(
      SchoolAccreditationsChunk chunk) async {
//    return await _writeFile(_basePath + _kSchoolAccreditationKey, chunk) !=
//        null;
  }

  @override
  Future<void> saveLookupsModel(Lookups model) async {
    final hiveLookups = HiveLookups.from(model)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    final box = await Hive.openBox(_kLookupsKey);
    box.put(0, hiveLookups);
  }

}
