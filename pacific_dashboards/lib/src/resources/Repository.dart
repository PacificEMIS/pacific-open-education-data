import 'dart:async';
import '../models/TeachersModel.dart';
import '../models/SchoolsModel.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();
  Future<SchoolsModel> fetchAllSchools();
}
