import 'dart:core';

import "package:collection/collection.dart";
import '../resources/ExamsDataNavigator.dart';
import 'ExamModel.dart';
import '../resources/Filter.dart';

class ExamsModel {
  List<ExamModel> _exams;
  List<ExamModel> get exams => _exams;
  ExamsDataNavigator examsDataNavigator;

  ExamsModel.fromJson(List parsedJson) {
    _exams = List<ExamModel>();
    _exams = parsedJson.map((i) => ExamModel.fromJson(i)).toList();
    examsDataNavigator = new ExamsDataNavigator(_exams);
  }

  List toJson() {
    return _exams.map((i) => (i).toJson()).toList();
  }
}