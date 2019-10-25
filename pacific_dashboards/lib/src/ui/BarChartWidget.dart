import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/src/config/Constants.dart';
import 'package:pacific_dashboards/src/utils/HexColor.dart';

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
  final Color color; 

  BarChartData(this.domain, this.measure, this.color);
}

class BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    List<BarChartData> data = [];
    widget.data.forEach((k, v) {
      data.add(BarChartData(k, v, HexColor.fromStringHash(k)));
    });

    var series = [
      charts.Series(
        domainFn: (BarChartData chartData, _) => chartData.domain,
        measureFn: (BarChartData chartData, _) => chartData.measure,
        colorFn: (BarChartData chartData, _) =>
            _getChartsColor(chartData.color),
        id: "name",
        data: data,
      ),
    ];

    return charts.BarChart(
      series,
      animate: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 10, color: _getChartsColor(AppColors.kNevada)),
          lineStyle: charts.LineStyleSpec(
            color: _getChartsColor(AppColors.kLoblolly),
          ),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 0, color: charts.MaterialPalette.gray.shadeDefault),
          lineStyle: charts.LineStyleSpec(
            color: _getChartsColor(AppColors.kLoblolly),
          ),
        ),
      ),
    );
  }

  // charts.Color _getChartsColorFromHex(int colorId) {
  //   String color = AppColors.kGridColors[colorId] ?? "#1A73E8";
  //   return charts.Color.fromHex(code: color);
  // }

  charts.Color _getChartsColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }
}
