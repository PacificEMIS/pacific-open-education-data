import 'package:flutter/material.dart';
import 'package:pacific_dashboards/shared_ui/pie_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/stacked_horizontal_bar_chart_widget.dart';
import 'package:pacific_dashboards/ui/BarChartWidget.dart';

class ChartFactory {
  static Widget createBarChartViewByData(Map<String, int> chartData) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 250.0,
            child: BarChartWidget(data: chartData),
          );
  }

  static Widget createPieChartViewByData(Map<String, int> chartData) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: PieChartWidget(data: chartData),
          );
  }

  static Widget createChart(ChartType type, Map<String, int> data) {
    switch (type) {
      case ChartType.bar:
        return createBarChartViewByData(data);
      case ChartType.pie:
        return createPieChartViewByData(data);
    }
    return null;
  } 

  static Widget getStackedHorizontalBarChartViewByData(
      {Map<String, List<int>> chartData, ColorFunc colorFunc}) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: StackedHorizontalBarChartWidget(
              data: chartData,
              colorFunc: colorFunc,
            ),
          );
  }
}

enum ChartType {
  bar, pie
}