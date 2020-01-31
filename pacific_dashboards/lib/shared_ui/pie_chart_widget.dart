import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

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
      data.add(PieChartData(k, v, HexColor.fromStringHash(k)));
    });
    data.sort((a, b) => b.measure.compareTo(a.measure));

    var series = [
      new charts.Series(
        id: "name",
        domainFn: (PieChartData chartData, _) => chartData.domain,
        measureFn: (PieChartData chartData, _) => chartData.measure,
        labelAccessorFn: (PieChartData chartData, _) => chartData.domain,
        colorFn: (PieChartData chartData, _) => chartData.color.chartsColor,
        data: data,
      ),
    ];

    return new charts.PieChart(
      series,
      animate: false,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 100,
        strokeWidthPx: 0.0,
      ),
    );
  }
}

class PieChartData {
  final String domain;
  final int measure;
  final Color color;

  PieChartData(this.domain, this.measure, this.color);
}