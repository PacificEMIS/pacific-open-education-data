import 'dart:async';

import '../models/teachers_model.dart';

import 'backend_provider.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  BackendProvider _backendProvider;

  RepositoryImpl(BackendProvider backendProvider) {
    this._backendProvider = backendProvider;
  }

  @override
  Future<TeachersModel> fetchAllTeachers() =>
      _backendProvider.fetchTeachersList();
}
