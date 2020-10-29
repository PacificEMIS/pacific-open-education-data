import 'package:arch/arch.dart' show Pair;
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';

abstract class HorizontalStackedScrollableBarChart extends StatelessWidget {
  const HorizontalStackedScrollableBarChart({
    Key key,
  }) : super(key: key);

  @protected
  List<ChartData> get chartData;

  @protected
  int get domainLength;

  @protected
  List<Pair<String, Color>> get legend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 300,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Container(
                    width: domainLength * 32.0,
                    child: charts.BarChart(
                      snapshot.data,
                      animate: false,
                      barGroupingType: charts.BarGroupingType.stacked,
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                          desiredMinTickCount: 7,
                          desiredMaxTickCount: 13,
                        ),
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          lineStyle: chartAxisLineStyle,
                        ),
                        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                              (number) => number.round().abs().toString(),
                        ),
                      ),
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          labelOffsetFromTickPx: -5,
                          labelOffsetFromAxisPx: 10,
                          labelAnchor: charts.TickLabelAnchor.before,
                          labelRotation: 270,
                          lineStyle: chartAxisLineStyle,
                        ),
                      ),
                      defaultRenderer: charts.BarRendererConfig(
                        stackHorizontalSeparator: 0,
                        minBarLengthPx: 30,
                        groupingType: charts.BarGroupingType.stacked,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(height: 6),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: legend.map((legendItem) {
            return ChartLegendItem(
              color: legendItem.second,
              value: legendItem.first.localized(context),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'data',
          data: chartData,
        )
      ];
    });
  }
}