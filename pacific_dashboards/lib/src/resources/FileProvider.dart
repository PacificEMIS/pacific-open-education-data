import 'dart:async';
import 'Provider.dart';
import '../models/schools_model.dart';
import '../models/teachers_model.dart';

abstract class FileProvider extends Provider{
  Future<String> loadFileData(String key);

  Future<bool> saveTeachersList(TeachersModel model);
  Future<bool> saveSchoolsList(SchoolsModel model);
}