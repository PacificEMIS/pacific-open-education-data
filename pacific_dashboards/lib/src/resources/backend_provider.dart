import 'dart:async';

import 'package:pacific_dashboards/src/models/schools_model.dart';
import '../models/teachers_model.dart';

abstract class BackendProvider {
  Future<TeachersModel> fetchTeachersList();
  Future<SchoolsModel> fetchSchoolsList();
}
