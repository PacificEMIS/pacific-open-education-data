import 'dart:async';
import '../models/TeachersModel.dart';
import '../models/SchoolsModel.dart';
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
    try {
      TeachersModel result = await _fileProvider.fetchValidTeachersModel();
      if (result == null) {
        result = await _backendProvider.fetchTeachersModel();
        await _fileProvider.saveTeachersModel(result);
      }
      return result;
    } catch (e) {
      return await _fileProvider.fetchTeachersModel();
    }
  }

  @override
  Future<SchoolsModel> fetchAllSchools() async {
    try {
      SchoolsModel result = await _fileProvider.fetchValidSchoolsModel();
      if (result == null) {
        result = await _backendProvider.fetchSchoolsModel();
        await _fileProvider.saveSchoolsModel(result);
      }
      return result;
    } catch (e) {
      return await _fileProvider.fetchSchoolsModel();
    }
  }
}
