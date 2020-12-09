import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({
    Key key,
    this.title,
    this.data,
    this.type,
  }) : super(key: key);

  final List<ChartData> data;
  final String title;
  final charts.BarGroupingType type;

  @override
  BarChartWidgetState createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.microtask(() {
        return [
          charts.Series(
            domainFn: (chartData, _) => chartData.domain,
            measureFn: (chartData, _) => chartData.measure,
            colorFn: (chartData, _) => chartData.color.chartsColor,
            id: widget.title,
            data: widget.data,
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
          barGroupingType: widget.type,
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: AppColors.kTextMinor.chartsColor),
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
