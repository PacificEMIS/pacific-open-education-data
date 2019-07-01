import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../utils/HexColor.dart';

class BarChartWidget extends StatefulWidget {
  final data;
  final title;

  BarChartWidget({Key key, this.title, this.data}) : super(key: key);

  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}

class BarChartData {
  final String domain;
  final int measure;

  BarChartData(this.domain, this.measure);
}

class BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    List<BarChartData> data = [];
    widget.data.forEach((k, v) {
      data.add(BarChartData(k, v));
    });

    var series = [
      charts.Series(
        domainFn: (BarChartData teachersData, _) => teachersData.domain,
        measureFn: (BarChartData teachersData, _) => teachersData.measure,
        colorFn: (BarChartData teachersData, _) => _getChartsColor(HexColor.fromStringHash(teachersData.domain)),
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
                  color: charts.MaterialPalette.gray.shadeDefault))),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 12,
                color: charts.MaterialPalette.gray.shadeDefault),
            lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shadeDefault)),
      ),
    );
  }

  charts.Color _getChartsColor(Color color) {
    return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }
}
