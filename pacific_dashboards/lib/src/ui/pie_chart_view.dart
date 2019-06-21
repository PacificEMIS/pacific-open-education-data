import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class PieChartView extends StatefulWidget {
  final bool animate;
  final data;

  PieChartView({Key key, this.data, this.animate}) : super(key: key);

  @override
  PieChartViewState createState() => PieChartViewState();
}

class PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    List<PieChartData> data = [];
    widget.data.forEach((k, v) {
      data.add(PieChartData(k, v));
    });

    var series = [
      new charts.Series(
        id: "name",
        domainFn: (PieChartData teachersData, _) => teachersData.domain,
        measureFn: (PieChartData teachersData, _) => teachersData.measure,
        data: data,
        labelAccessorFn: (PieChartData row, _) => '${row.domain}',
      ),
    ];

    return new charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [charts.ArcLabelDecorator()]),
    );
  }
}

class PieChartData {
  final String domain;
  final int measure;

  PieChartData(this.domain, this.measure);
}
