import 'dart:async';
import '../models/TeachersModel.dart';
import '../resources/FileProvider.dart';
import 'Provider.dart';
import 'Repository.dart';

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
      final result = await _backendProvider.fetchTeachersModel();
      _fileProvider.saveTeachersModel(result);
      return result;
    } catch (e) {
      return _fileProvider.fetchTeachersModel();
    }
  }
}
