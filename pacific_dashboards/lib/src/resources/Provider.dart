import 'dart:async';
import '../models/ExamsModel.dart';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';

abstract class Provider {
  Future<TeachersModel> fetchTeachersModel();

  Future<SchoolsModel> fetchSchoolsModel();

  Future<ExamsModel> fetchExamsModel();
}
