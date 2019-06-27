import 'dart:async';

import '../models/teachers_model.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();
}
