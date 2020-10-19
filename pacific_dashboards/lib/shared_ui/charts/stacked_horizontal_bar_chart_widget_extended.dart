import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';

typedef Color ColorFunc(int index);

class StackedHorizontalBarChartWidgetExtended extends StatefulWidget {
  final Map<String, List<int>> data;
  final ColorFunc colorFunc;

  StackedHorizontalBarChartWidgetExtended({
    Key key,
    @required this.data,
    this.colorFunc,
  }) : super(key: key);

  @override
  StackedHorizontalBarChartWidgetExtendedState createState() =>
      StackedHorizontalBarChartWidgetExtendedState();
}

class StackedHorizontalBarChartWidgetExtendedState
    extends State<StackedHorizontalBarChartWidgetExtended> {
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
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
              (number) =>
          number.round().abs().toString(),
        ),
        // viewport: charts.NumericExtents(-400, 400),
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
    );
  }

  List<charts.Series<_Data, String>> _createSeries(
    Map<String, List<int>> data,
  ) {
    final length = _getDataLengthWithChecks(data);
    final series = List<charts.Series<_Data, String>>();

    for (var i = 0; i < length; i++) {
      final chunk = List<_Data>();
      data.forEach((key, values) {
        chunk.add(_Data(
            domain: key,
            measure: values[i],
            color: widget.colorFunc != null
                ? widget.colorFunc(i)
                : HexColor.fromStringHash(values[i].toString())));
      });
      series.add(charts.Series<_Data, String>(
        id: 'series_${i.toString()}',
        domainFn: (_Data data, int _) => data.domain,
        measureFn: (_Data data, int _) => data.measure,
        colorFn: (_Data data, int _) => data.color.chartsColor,
        data: chunk,
      ));
    }

    return series;
  }

  int _getDataLengthWithChecks(Map<String, List<int>> data) {
    var length = -1;
    data.forEach((_, value) {
      if (length == -1) {
        length = value.length;
      } else if (value.length != length) {
        throw Exception("Inconsistent data arrays");
      }
    });
    return length;
  }
}

class _Data {
  final String domain;
  final int measure;
  final Color color;

  _Data({this.domain, this.measure, this.color});
}
