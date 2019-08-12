import 'dart:async';
import '../models/ExamsModel.dart';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';
import 'Provider.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveExamsModel(ExamsModel model);

  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);

  Future<ExamsModel> fetchValidExamsModel();

  Future<SchoolsModel> fetchValidSchoolsModel();

  Future<TeachersModel> fetchValidTeachersModel();
}
