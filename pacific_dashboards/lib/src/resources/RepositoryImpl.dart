import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import 'package:pacific_dashboards/src/resources/FileProvider.dart';
import 'package:pacific_dashboards/src/resources/Provider.dart';
import 'package:pacific_dashboards/src/resources/Repository.dart';

class RepositoryImpl implements Repository {
  Provider _backendProvider;
  FileProvider _fileProvider;

  RepositoryImpl(Provider backendProvider, FileProvider fileProvider) {
    this._backendProvider = backendProvider;
    this._fileProvider = fileProvider;
  }

  @override
  Future<TeachersModel> fetchAllTeachers() async {
    TeachersModel result;
    try {
      result = await _fileProvider.fetchValidTeachersModel();
      if (result == null) {
        result = await _backendProvider.fetchTeachersModel();
        await _fileProvider.saveTeachersModel(result);
      }
    } catch (e) {
      result = await _fileProvider.fetchTeachersModel();
    }
    result.lookupsModel = await fetchAllLookups();
    return result;
  }

  @override
  Future<SchoolsModel> fetchAllSchools() async {
    SchoolsModel result;
    try {
      result = await _fileProvider.fetchValidSchoolsModel();
      if (result == null) {
        result = await _backendProvider.fetchSchoolsModel();
        await _fileProvider.saveSchoolsModel(result);
      }
    } catch (e) {
      result = await _fileProvider.fetchSchoolsModel();
    }
    result.lookupsModel = await fetchAllLookups();
    return result;
  }

  @override
  Future<ExamsModel> fetchAllExams() async {
    ExamsModel result;
    try {
      result = await _fileProvider.fetchValidExamsModel();
      if (result == null) {
        result = await _backendProvider.fetchExamsModel();
        await _fileProvider.saveExamsModel(result);
      }
    } catch (e) {
      result = await _fileProvider.fetchExamsModel();
    }
    result.lookupsModel = await fetchAllLookups();
    return result;
  }

  @override
  Future<SchoolAccreditationsChunk> fetchAllAccreditaitons() async {
    SchoolAccreditationsChunk result;
    try {
      result = await _fileProvider.fetchValidSchoolAccreditationsChunk();
      if (result == null) {
        result = await _backendProvider.fetchSchoolAccreditationsChunk();
        await _fileProvider.saveSchoolAccreditaitonsChunk(result);
      }
    } catch (e) {
      result = await _fileProvider.fetchSchoolAccreditationsChunk();
    }
    final lookups = await fetchAllLookups();
    result.statesChunk.lookupsModel = lookups;
    result.standardsChunk.lookupsModel = lookups;
    return result;
  }

  @override
  Future<LookupsModel> fetchAllLookups() async {
    try {
      LookupsModel result = await _fileProvider.fetchValidLookupsModel();
      if (result == null) {
        result = await _backendProvider.fetchLookupsModel();
        await _fileProvider.saveLookupsModel(result);
      }
      return result;
    } catch (e) {
      return await _fileProvider.fetchLookupsModel();
    }
  }
}
