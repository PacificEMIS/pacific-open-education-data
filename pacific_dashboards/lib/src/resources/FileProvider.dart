import 'dart:async';
import 'Provider.dart';
import '../models/schools_model.dart';
import '../models/teachers_model.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);
}
