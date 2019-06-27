import 'dart:async';

import '../models/schools_model.dart';
import '../models/teachers_model.dart';

abstract class BackendProvider {
  Future<TeachersModel> fetchTeachersList();
  Future<SchoolsModel> fetchSchoolsList();
}
