import 'dart:async';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';

abstract class Provider {
  Future<TeachersModel> fetchTeachersModel();

  Future<SchoolsModel> fetchSchoolsModel();
}
