import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

import '../wash_data.dart';

class WaterComponent extends StatefulWidget {
  final String year;
  final Map<String, List<WaterData>> data;

  const WaterComponent({
    Key key,
    @required this.year,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _WaterComponentState createState() => _WaterComponentState();
}

class _WaterComponentState extends State<WaterComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MiniTabLayout(
          tabs: ['Used for drinking', 'Currently Available'],
          tabNameBuilder: (tab) {
            return '$tab';
          },
          builder: (ctx, tab) {
            return _Chart(
                data: widget.data,
                groupingType: charts.BarGroupingType.stacked);
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  final Map<String, List<WaterData>> _data;
  final charts.BarGroupingType _groupingType;

  const _Chart(
      {Key key,
      @required Map<String, List<WaterData>> data,
      @required charts.BarGroupingType groupingType})
      : assert(data != null),
        _data = data,
        _groupingType = groupingType,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 300,
          width: 400,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(30),
                  child: Container(
                    width: ((snapshot.data[0].data as List).length * 2)
                        .toDouble(),
                    child: charts.BarChart(
                      snapshot.data,
                      animate: false,
                      barGroupingType: _groupingType,
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                          desiredMinTickCount: 7,
                          desiredMaxTickCount: 13,
                        ),
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          lineStyle: chartAxisLineStyle,
                        ),
                      ),
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          labelOffsetFromTickPx: -5,
                          labelOffsetFromAxisPx: 10,
                          labelAnchor: charts.TickLabelAnchor.before,
                          // minimumPaddingBetweenLabelsPx: 2,
                          labelRotation: 270,
                          lineStyle: chartAxisLineStyle,
                        ),
                      ),
                      defaultRenderer: charts.BarRendererConfig(
                        stackHorizontalSeparator: 0,
                        minBarLengthPx: 30,
                        groupingType: charts.BarGroupingType.stacked,
                        strokeWidthPx: 10,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(height: 50),
        Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: getColumnTitles(_data)),
      ],
    );
  }

  List<Widget> getColumnTitles(Map<String, List<WaterData>> data) {
    List<Widget> list = new List<Widget>();
    List<String> titles = new List<String>();
    data.forEach((key, value) {
      titles.addAll(value[0].values.keys);
    });
    titles = titles.toSet().toList();
    if (titles.length > 0) {
      titles.forEach((it) {
        list.add(
          ChartLegendItem(
              color: HexColor.fromStringHash(it), value: it == null ? 'na' : it),
        );
      });
    }
    return list;
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      final data = List<ChartData>();
      var dataLength = _data.length;
      _data.forEach((key, value) {
        value.forEach((element) {
          element.values.forEach((key, value) {
            data.add(ChartData(element.title, value,
                HexColor.fromStringHash(key)));
          });
        });
      });

      debugPrint(data[0].domain.toString());
      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'spending_Data',
          data: data,
        )
      ];
    });
  }

  T enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value,
        orElse: () => null);
  }
}
