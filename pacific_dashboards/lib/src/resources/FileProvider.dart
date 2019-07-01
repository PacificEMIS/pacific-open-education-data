import 'dart:async';
import 'Provider.dart';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);

  Future<SchoolsModel> fetchValidSchoolsModel();

  Future<TeachersModel> fetchValidTeachersModel();
}
