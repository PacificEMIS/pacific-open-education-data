import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/src/config/Constants.dart';

class HorizontalStackedBarChartWidget extends StatefulWidget {
  final data;
  final title;

  HorizontalStackedBarChartWidget({Key key, this.title, this.data}) : super(key: key);

  @override
  HorizontalStackedBarChartWidgetState createState() =>
      HorizontalStackedBarChartWidgetState();
}

class HorizontalBarChartData {
  final String domain;
  final int measure;
  final int color;

  HorizontalBarChartData(this.domain, this.measure, this.color);
}

class HorizontalStackedBarChartWidgetState extends State<HorizontalStackedBarChartWidget> {
  @override
  Widget build(BuildContext context) {
    List<HorizontalBarChartData> data = [];
    int id = 0;
    widget.data.forEach((k, v) {
      id++;
      data.add(HorizontalBarChartData(k, v, id));
    });

    var series = [
      charts.Series(
        domainFn: (HorizontalBarChartData chartData, _) => chartData.domain,
        measureFn: (HorizontalBarChartData chartData, _) => chartData.measure,
        colorFn: (HorizontalBarChartData chartData, _) =>
            _getChartsColorFromHex(chartData.color),
        id: "name",
        data: data,
      ),
    ];

    return charts.BarChart(
      series,
      animate: false,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
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

  charts.Color _getChartsColorFromHex(int colorId) {
    String color = AppColors.kGridColors[colorId] ?? "#1A73E8";
    return charts.Color.fromHex(code: color);
  }

  charts.Color _getChartsColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }
}
