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
  Future<TeachersModel> fetchAllTeachers() async{
    //return TeachersModel.fromJson(json.decode(await .loadFileData(_dataApiKey)));
    try {
      print('fetchAllTeachers');
      final result = await _backendProvider.fetchTeachersList();
      _fileProvider.saveTeachersList(result);
      return result;
    } catch (e) {
      print('fetchAllTeachers load file');
      return await _fileProvider.fetchTeachersList();
    }

  }
}
