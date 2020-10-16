import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';

class BarChartStackedWidget extends StatefulWidget {
  final Map<String, Map<String, int>> data;
  final String title;
  final charts.BarGroupingType type;

  BarChartStackedWidget({Key key, this.title, this.data, this.type})
      : super(key: key);

  @override
  BarChartStackedWidgetState createState() => BarChartStackedWidgetState();
}

class BarChartStackedWidgetState extends State<BarChartStackedWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.microtask(() {
        Map<String, List<ChartData>> data = Map();
        widget.data.forEach((k, v) {
          List<ChartData> chartData = new List();
          v.forEach((key, value) {
            chartData.add(ChartData(key, value, HexColor.fromStringHash(k)));
          });
          data[k] = chartData;
        });
        List<ChartData> seriesWidgets = [];
        data.forEach((key, value) {
          seriesWidgets.addAll(value);
        });
        List<ChartData> test = [];
        test.add(seriesWidgets.first);
        return [
          charts.Series(
            domainFn: (ChartData chartData, _) => chartData.domain,
            measureFn: (ChartData chartData, _) => chartData.measure,
            colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
            id: 'test',
            data: test,
          )
        ];
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return charts.BarChart(
          snapshot.data,
          animate: false,
          barGroupingType: charts.BarGroupingType.stacked,
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
