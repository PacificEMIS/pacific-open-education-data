import 'package:flutter/material.dart';

import '../models/teacher_model.dart';

import 'bar_chart_view.dart';
import 'pie_chart_view.dart';

class ChartFactory {
  static Widget getBarChartViewByData(
      Map<dynamic, List<TeacherModel>> chartData) {
    var map = new Map<String, int>();
    chartData.forEach((k, v) {
      map[k] = v.length;
    });

    return BarChartView(data: map);
  }

  static Widget getPieChartViewByData(
      Map<dynamic, List<TeacherModel>> chartData) {
    var map = new Map<String, int>();
    chartData.forEach((k, v) {
      map[k] = v.length;
    });

    return PieChartView(data: map);
  }
}
