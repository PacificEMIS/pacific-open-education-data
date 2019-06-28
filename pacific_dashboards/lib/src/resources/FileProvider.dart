import 'dart:async';
import '../models/SchoolsModel.dart';
import '../models/TeachersModel.dart';
import 'Provider.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);
}
