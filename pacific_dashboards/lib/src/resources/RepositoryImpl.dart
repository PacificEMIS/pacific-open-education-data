import 'dart:async';
import '../models/teachers_model.dart';
import 'Provider.dart';
import 'repository.dart';
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
      print('fetchAllTeachers');
      final result = await _backendProvider.fetchTeachersModel();
      _fileProvider.saveTeachersModel(result);
      return result;
    } catch (e) {
      print('fetchAllTeachers load file');
      return _fileProvider.fetchTeachersModel();
    }
  }
}
