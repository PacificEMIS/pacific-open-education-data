import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

class LocalDataSourceImpl extends LocalDataSource {
  final Database _database;
  final GlobalSettings _globalSettings;

  LocalDataSourceImpl(this._database, this._globalSettings);

  Future<Emis> get _emis => _globalSettings.currentEmis;

  @override
  Future<BuiltList<School>> fetchSchoolsModel() async =>
      await _database.schools.get(await _emis);

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
    return await _database.lookups.get(await _emis);
  }

  @override
  Future<void> saveSchools(BuiltList<School> schools) async =>
      await _database.schools.save(schools, await _emis);

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
  Future<void> saveLookupsModel(Lookups model) async =>
      await _database.lookups.save(model, await _emis);
}
