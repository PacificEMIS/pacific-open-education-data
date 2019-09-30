import 'dart:core';

import 'package:pacific_dashboards/src/models/ModelWithLookups.dart';
import 'package:pacific_dashboards/src/resources/SchoolAccreditationsDataNavigator.dart';

import 'SchoolAccrediatationModel.dart';

class SchoolAccreditationsModel extends ModelWithLookups {
  List<SchoolAccreditationModel> _accrediations;

  List<SchoolAccreditationModel> get exams => _accrediations;
  SchoolAccreditationsDataNavigator schoolAccreditationsDataNavigator;

  SchoolAccreditationsModel.fromJson(List parsedJson) {
    _accrediations = List<SchoolAccreditationModel>();
    _accrediations = parsedJson.map((i) => SchoolAccreditationModel.fromJson(i)).toList();
    schoolAccreditationsDataNavigator = new SchoolAccreditationsDataNavigator(_accrediations, this);
  }

  List toJson() {
    return _accrediations.map((i) => (i).toJson()).toList();
  }
}
