import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class PieChartView extends StatefulWidget {
  final bool animate;
  final data;

  PieChartView({Key key, this.data, this.animate}) : super(key: key);

  @override
  PieChartViewState createState() => new PieChartViewState();
}

class PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    List<TeachersData> data = [];
    widget.data.forEach((k, v) {
      data.add(new TeachersData(k, v));
    });

    var series = [
      new charts.Series(
        id: "name",
        domainFn: (TeachersData teachersData, _) => teachersData.name,
        measureFn: (TeachersData teachersData, _) => teachersData.value,
        data: data,
        labelAccessorFn: (TeachersData row, _) => '${row.name}',
      ),
    ];

    return new charts.PieChart(
      series,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]),
    );
  }
}

class TeachersData {
  final String name;
  final int value;

  TeachersData(this.name, this.value);
}
