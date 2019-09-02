import 'dart:core';

import 'package:pacific_dashboards/src/models/ExamModel.dart';
import 'package:pacific_dashboards/src/models/ModelWithLookups.dart';
import 'package:pacific_dashboards/src/resources/ExamsDataNavigator.dart';

class ExamsModel extends ModelWithLookups {
  List<ExamModel> _exams;

  List<ExamModel> get exams => _exams;
  ExamsDataNavigator examsDataNavigator;

  ExamsModel.fromJson(List parsedJson) {
    _exams = List<ExamModel>();
    _exams = parsedJson.map((i) => ExamModel.fromJson(i)).toList();
    examsDataNavigator = new ExamsDataNavigator(_exams, this);
  }

  List toJson() {
    return _exams.map((i) => (i).toJson()).toList();
  }
}
