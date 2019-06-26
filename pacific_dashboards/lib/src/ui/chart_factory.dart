import 'package:flutter/material.dart';

import '../models/teacher_model.dart';

import 'bar_chart_widget.dart';
import 'pie_chart_widget.dart';

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
