import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';

class PieChartWidget extends StatefulWidget {
  final bool animate;
  final List<ChartData> data;

  PieChartWidget({
    Key key,
    this.data,
    this.animate,
  }) : super(key: key);

  @override
  PieChartWidgetState createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.microtask(() {
        return [
          charts.Series(
            id: "name",
            domainFn: (ChartData chartData, _) => chartData.domain,
            measureFn: (ChartData chartData, _) => chartData.measure,
            labelAccessorFn: (ChartData chartData, _) => chartData.domain,
            colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
            data: widget.data,
          ),
        ];
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return charts.PieChart(
          snapshot.data,
          animate: widget.animate,
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 100,
            strokeWidthPx: 0.0,
          ),
        );
      },
    );
  }
}