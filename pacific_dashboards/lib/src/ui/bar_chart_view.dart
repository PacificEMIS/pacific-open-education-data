import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class BarChartView extends StatefulWidget {
  final data;
  final title;

  BarChartView({Key key, this.title, this.data}) : super(key: key);

  @override
  BarChartViewState createState() => BarChartViewState();
}

class BarChartData {
  final String domain;
  final int measure;

  BarChartData(this.domain, this.measure);
}

class BarChartViewState extends State<BarChartView> {
  @override
  Widget build(BuildContext context) {
    List<BarChartData> data = [];
    widget.data.forEach((k, v) {
      data.add(BarChartData(k, v));
    });

    var series = [
      charts.Series(
        domainFn: (BarChartData teachersData, _) => teachersData.domain,
        measureFn: (BarChartData teachersData, _) =>
            teachersData.measure,
        colorFn: (BarChartData teachersData, _) =>
            charts.MaterialPalette.white,
        id: "name",
        data: data,
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 8, color: charts.MaterialPalette.white),
              lineStyle: charts.LineStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault))),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 12,
                color: charts.MaterialPalette.deepOrange.shadeDefault),
            lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.green.shadeDefault)),
      ),
    );
  }
}
