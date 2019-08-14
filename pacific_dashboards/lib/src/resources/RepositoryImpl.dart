import 'dart:async';
import '../models/ExamsModel.dart';
import '../models/TeachersModel.dart';
import '../models/SchoolsModel.dart';
import '../models/LookupsModel.dart';
import 'Provider.dart';
import 'Repository.dart';
import '../resources/FileProvider.dart';

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
