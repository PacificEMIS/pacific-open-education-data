import 'dart:async';

import '../models/teachers_model.dart';
import 'charts_api_provider.dart';

class Repository {
  final chartsApiProvider = ChartsApiProvider();

  Future<TeachersModel> fetchAllTeachers() =>
      chartsApiProvider.fetchTeachersList();
}
