import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/shared_ui/bar_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/pie_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/stacked_horizontal_bar_chart_widget.dart';

class ChartFactory {
  static Widget createBarChartViewByData(
      Map<String, int> chartData, charts.BarGroupingType type) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 250.0,
            child: BarChartWidget(key: ObjectKey(chartData), data: chartData),
          );
  }

  static Widget createPieChartViewByData(Map<String, int> chartData) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: PieChartWidget(key: ObjectKey(chartData), data: chartData),
          );
  }

  static Widget createChart(ChartType type, Map<String, int> data) {
    switch (type) {
      case ChartType.bar:
        return createBarChartViewByData(data, null);
      case ChartType.stackedBar:
        return createBarChartViewByData(data, charts.BarGroupingType.stacked);
      case ChartType.horizontalStackedBar:
        return createBarChartViewByData(
            data, charts.BarGroupingType.groupedStacked);
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

enum ChartType { bar, stackedBar, horizontalStackedBar, pie }
