import 'dart:core';

import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import 'package:pacific_dashboards/src/resources/Provider.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveExamsModel(ExamsModel model);

  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);

  Future<bool> saveSchoolAccreditaitonsModel(SchoolAccreditationsModel model);

  Future<bool> saveLookupsModel(LookupsModel model);

  Future<ExamsModel> fetchValidExamsModel();

  Future<SchoolsModel> fetchValidSchoolsModel();

  Future<TeachersModel> fetchValidTeachersModel();

  Future<SchoolAccreditationsModel> fetchValidSchoolAccreditationsModel();

  Future<LookupsModel> fetchValidLookupsModel();
}