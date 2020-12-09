import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';

typedef ColorFunc = Color Function(int index);

class StackedHorizontalBarChartWidgetExtended extends StatefulWidget {
  const StackedHorizontalBarChartWidgetExtended({
    Key key,
    @required this.data,
    @required this.legend,
    this.colorFunc,
  }) : super(key: key);

  final Map<String, TeachersByCertification> data;
  final List<String> legend;
  final ColorFunc colorFunc;

  @override
  StackedHorizontalBarChartWidgetExtendedState createState() =>
      StackedHorizontalBarChartWidgetExtendedState();
}

class StackedHorizontalBarChartWidgetExtendedState
    extends State<StackedHorizontalBarChartWidgetExtended> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 300,
            width: 400,
            child: charts.BarChart(
              _createSeries(widget.data),
              animate: false,
              barGroupingType: charts.BarGroupingType.stacked,
              vertical: false,
              defaultInteractions: false,
              primaryMeasureAxis: charts.NumericAxisSpec(
                showAxisLine: false,
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: chartAxisTextStyle,
                  lineStyle: chartAxisLineStyle,
                ),
                tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 5,
                ),
                tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (number) => number.round().abs().toString(),
                ),
              ),
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.MaterialPalette.gray.shadeDefault,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    color: AppColors.kCoolGray.chartsColor,
                  ),
                ),
              ),
              defaultRenderer: charts.BarRendererConfig(
                stackHorizontalSeparator: 0,
                groupingType: charts.BarGroupingType.stacked,
                strokeWidthPx: 1,
              ),
            ),
          ),
          Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: getColumnTitles(widget.legend))
        ]);
  }

  List<Widget> getColumnTitles(List<String> legend) {
    final widgetList = <Widget>[];
    for (var i = 0; i < legend.length; i++) {
      widgetList.add(
        ChartLegendItem(
          color: widget.colorFunc(i),
          value: legend[i].localized(context),
        ),
      );
    }
    return widgetList;
  }

  List<charts.Series<_Data, String>> _createSeries(
    Map<String, TeachersByCertification> data,
  ) {
    final series = <charts.Series<_Data, String>>[];

    final chunk = <_Data>[];
    data.forEach((key, values) {
      generateChunk(chunk, key, 0, values.certifiedAndQualifiedFemale, series);
      generateChunk(chunk, key, 1, values.qualifiedFemale, series);
      generateChunk(chunk, key, 2, values.certifiedFemale, series);
      generateChunk(chunk, key, 3, values.numberTeachersFemale, series);
      generateChunk(chunk, key, 4, values.certifiedAndQualifiedMale, series);
      generateChunk(chunk, key, 5, values.qualifiedMale, series);
      generateChunk(chunk, key, 6, values.certifiedMale, series);
      generateChunk(chunk, key, 7, values.numberTeachersMale, series);
    });

    series.add(charts.Series<_Data, String>(
        id: 'series',
        domainFn: (data, _) => data.domain,
        measureFn: (data, _) => data.measure,
        colorFn: (data, _) => data.color.chartsColor,
        data: chunk));
    return series;
  }

  void generateChunk(
    List<_Data> chunk,
    String key,
    int color,
    int value,
    List<charts.Series<_Data, String>> series,
  ) {
    chunk.add(
      _Data(
        domain: key,
        measure: value,
        color: widget.colorFunc != null
            ? widget.colorFunc(color)
            : HexColor.fromStringHash(color.toString()),
      ),
    );
  }
}

class _Data {
  const _Data({this.domain, this.measure, this.color});

  final String domain;
  final int measure;
  final Color color;
}
