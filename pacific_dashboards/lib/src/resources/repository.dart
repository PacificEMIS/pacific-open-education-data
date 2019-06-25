import 'dart:async';

import '../models/teachers_model.dart';
import 'charts_api_provider.dart';

abstract class Repository {
  ChartsApiProvider get chartsApiProvider;

  Future<TeachersModel> fetchAllTeachers();
}
