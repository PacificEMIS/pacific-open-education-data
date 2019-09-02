import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/src/utils/HexColor.dart';

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
        domainFn: (PieChartData chartData, _) => chartData.domain,
        measureFn: (PieChartData chartData, _) => chartData.measure,
        colorFn: (PieChartData chartData, _) =>
            _getChartsColor(HexColor.fromStringHash(chartData.domain)),
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

  charts.Color _getChartsColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }
}

class PieChartData {
  final String domain;
  final int measure;

  PieChartData(this.domain, this.measure);
}
