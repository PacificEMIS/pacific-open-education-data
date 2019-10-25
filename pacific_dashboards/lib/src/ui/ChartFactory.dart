import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/BarChartWidget.dart';
import 'package:pacific_dashboards/src/ui/PieChartWidget.dart';
import 'package:pacific_dashboards/src/ui/StackedHorizontalBarChartWidget.dart';

class ChartFactory {
  static Widget getBarChartViewByData(Map<dynamic, int> chartData) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 250.0,
            child: BarChartWidget(data: chartData),
          );
  }

  static Widget getPieChartViewByData(Map<dynamic, int> chartData) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: PieChartWidget(data: chartData),
          );
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

class OrdinalSales {
  final String year;
  final int accreditated;

  OrdinalSales(this.year, this.accreditated);
}
