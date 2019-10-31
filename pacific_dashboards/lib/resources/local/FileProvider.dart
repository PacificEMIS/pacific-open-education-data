import 'dart:core';

import 'package:pacific_dashboards/models/ExamsModel.dart';
import 'package:pacific_dashboards/models/LookupsModel.dart';
import 'package:pacific_dashboards/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/models/SchoolsModel.dart';
import 'package:pacific_dashboards/models/TeachersModel.dart';
import 'package:pacific_dashboards/resources/Provider.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveExamsModel(ExamsModel model);

  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);

  Future<bool> saveSchoolAccreditaitonsChunk(SchoolAccreditationsChunk chunk);

  Future<bool> saveLookupsModel(LookupsModel model);
}