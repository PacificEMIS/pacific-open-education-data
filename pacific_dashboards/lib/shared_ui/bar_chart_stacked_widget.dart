import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

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
        Map<String, List<BarChartData>> data = Map();
        widget.data.forEach((k, v) {
          List<BarChartData> chartData = new List();
          v.forEach((key, value) {
            chartData.add(BarChartData(key, value, HexColor.fromStringHash(k)));
          });
          data[k] = chartData;
        });
        List<BarChartData> seriesWidgets = [];
        data.forEach((key, value) {
          seriesWidgets.addAll(value);
        });
        List<BarChartData> test = [];
        test.add(seriesWidgets.first);
        return [
          charts.Series(
            domainFn: (BarChartData chartData, _) => chartData.domain,
            measureFn: (BarChartData chartData, _) => chartData.measure,
            colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
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
