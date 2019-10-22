import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/BarChartWidget.dart';
import 'package:pacific_dashboards/src/ui/PieChartWidget.dart';
import 'package:pacific_dashboards/src/ui/StackedHorizontalBarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'StackedHorizontalBarChartAccreditations.dart';

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

  static Widget getHorizontalBarChartViewByData(Map<dynamic, int> chartData) {
    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    List<int> listTab = new List();


    var series = new charts.Series<OrdinalSales, String>(
      id: 'Desktop',
      domainFn: (OrdinalSales sales, _) => sales.year,
      measureFn: (OrdinalSales sales, _) => sales.accreditated,
      data: tableSalesData,
    );
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: StackedHorizontalBarChartAccreditations([series]),
          );
  }
}

class OrdinalSales {
  final String year;
  final int accreditated;

  OrdinalSales(this.year, this.accreditated);
}
