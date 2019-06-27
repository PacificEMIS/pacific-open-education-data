import 'dart:async';

import '../models/teachers_model.dart';
import 'charts_api_provider.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final _chartsApiProvider = ChartsApiProvider();

  @override
  Future<TeachersModel> fetchAllTeachers() =>
      _chartsApiProvider.fetchTeachersList();
}
