import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class PieChartWidget extends StatefulWidget {
  final bool animate;
  final data;

  PieChartWidget({Key key, this.data, this.animate}) : super(key: key);

  @override
  PieChartWidgetState createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
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
          arcWidth: 100,
          arcRendererDecorators: [charts.ArcLabelDecorator(showLeaderLines: false)]),
    );
  }
}

class PieChartData {
  final String domain;
  final int measure;

  PieChartData(this.domain, this.measure);
}
