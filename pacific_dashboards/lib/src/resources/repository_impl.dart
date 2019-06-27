import 'dart:async';

import '../models/teachers_model.dart';

import 'backend_provider.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final BackendProvider backendProvider;

  RepositoryImpl( {this.backendProvider} );

  @override
  Future<TeachersModel> fetchAllTeachers() =>
      backendProvider.fetchTeachersList();
}
