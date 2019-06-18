import 'package:flutter/material.dart';

import '../models/chart_model.dart';
import 'bar_chart_view.dart';
import 'round_chart_view.dart';

class ChartFactory {
  static Widget getChartViewByData(ChartModel chartData) {
    if (chartData.chartType == 'Bar') {
      return BarChartView(
        data: chartData,
      );
    } else if (chartData.chartType == 'Circle') {
      return RoundChartView(
        data: chartData,
      );
    }

    return Container(
      child: Text('unknown chart'),
    );
  }

  static Widget getChartDetailByData(ChartModel chartData) {
    if (chartData.chartType == 'Bar') {
      return BarChartView(
        data: chartData,
      );
    } else if (chartData.chartType == 'Circle') {
      return RoundChartView(
        data: chartData,
      );
    }

    return Container(
      child: Text('wtf'),
    );
  }
}
