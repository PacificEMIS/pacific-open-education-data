import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

class BarChartWidget extends StatefulWidget {
  final Map<String, int> data;
  final String title;

  BarChartWidget({Key key, this.title, this.data}) : super(key: key);

  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}

class BarChartData {
  final String domain;
  final int measure;
  final Color color;

  const BarChartData(this.domain, this.measure, this.color);
}

class BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.microtask(() {
        List<BarChartData> data = [];
        widget.data.forEach((k, v) {
          data.add(BarChartData(k, v, HexColor.fromStringHash(k)));
        });

        return [
          charts.Series(
            domainFn: (BarChartData chartData, _) => chartData.domain,
            measureFn: (BarChartData chartData, _) => chartData.measure,
            colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
            id: widget.title,
            data: data,
          ),
        ];
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return charts.BarChart(
          snapshot.data,
          animate: false,
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: AppColors.kNevada.chartsColor),
              lineStyle: charts.LineStyleSpec(
                color: AppColors.kCoolGray.chartsColor,
              ),
            ),
          ),
          domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 0, color: charts.MaterialPalette.gray.shadeDefault),
              lineStyle: charts.LineStyleSpec(
                color: AppColors.kCoolGray.chartsColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
