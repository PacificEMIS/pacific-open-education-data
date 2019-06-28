import 'package:flutter/material.dart';
import '../models/TeacherModel.dart';

import 'BarChartWidget.dart';
import 'PieChartWidget.dart';

class ChartFactory {
  static Widget getBarChartViewByData(
      Map<dynamic, List<TeacherModel>> chartData) {
    var map = Map<String, int>();
    chartData.forEach((k, v) {
      map[k] = v.length;
    });

    return BarChartWidget(data: map);
  }

  static Widget getPieChartViewByData(
      Map<dynamic, List<TeacherModel>> chartData) {
    var map = Map<String, int>();
    chartData.forEach((k, v) {
      map[k] = v.length;
    });

  return PieChartWidget(data: map);
  }
}
