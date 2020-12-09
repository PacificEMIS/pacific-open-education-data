import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';

typedef ColorFunc = Color Function(int index);

class StackedHorizontalBarChartWidget extends StatefulWidget {
  const StackedHorizontalBarChartWidget({
    Key key,
    @required this.data,
    this.colorFunc,
  }) : super(key: key);

  final Map<String, List<int>> data;
  final ColorFunc colorFunc;

  @override
  StackedHorizontalBarChartWidgetState createState() =>
      StackedHorizontalBarChartWidgetState();
}

class StackedHorizontalBarChartWidgetState
    extends State<StackedHorizontalBarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeries(widget.data),
      animate: false,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: AppColors.kTextMinor.chartsColor,
          ),
          lineStyle: charts.LineStyleSpec(
            color: AppColors.kCoolGray.chartsColor,
          ),
        ),
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          dataIsInWholeNumbers: true,
          desiredMaxTickCount: 10,
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
    );
  }

  List<charts.Series<_Data, String>> _createSeries(
    Map<String, List<int>> data,
  ) {
    final length = _getDataLengthWithChecks(data);
    final series = <charts.Series<_Data, String>>[];

    for (var i = 0; i < length; i++) {
      final chunk = <_Data>[];
      data.forEach((key, values) {
        chunk.add(
          _Data(
            domain: key,
            measure: values[i],
            color: widget.colorFunc != null
                ? widget.colorFunc(i)
                : HexColor.fromStringHash(values[i].toString()),
          ),
        );
      });
      series.add(charts.Series<_Data, String>(
        id: 'series_${i.toString()}',
        domainFn: (data, _) => data.domain,
        measureFn: (data, _) => data.measure,
        colorFn: (data, _) => data.color.chartsColor,
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
        throw Exception('Inconsistent data arrays');
      }
    });
    return length;
  }
}

class _Data {
  const _Data({this.domain, this.measure, this.color});

  final String domain;
  final int measure;
  final Color color;
}
