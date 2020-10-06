import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

import '../wash_data.dart';

class WaterComponent extends StatefulWidget {
  final List<ListData> data;
  final String year;
  final bool showAllData;

  const WaterComponent({
    Key key,
    @required this.data,
    @required this.year,
    @required this.showAllData,
  })  : assert(data != null),
        assert(year != null),
        assert(showAllData != null),
        super(key: key);

  @override
  _WaterComponentState createState() => _WaterComponentState();
}
class _WaterComponentState extends State<WaterComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length == 0) {
      return Center(
        child: Text(
          'labelNoData'.localized(context),
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MiniTabLayout(
          tabs: _DashboardTab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _DashboardTab.cumulative:
                return 'washUsedForDrinking'.localized(context);
              case _DashboardTab.evaluated:
                return 'washCurrentlyAvailable'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _DashboardTab.cumulative:
                return _Chart(
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.evaluated:
                return _Chart(
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

enum _DashboardTab {
  cumulative,
  evaluated,
}

class _Chart extends StatelessWidget {
  final List<ListData> _data;
  final charts.BarGroupingType _groupingType;
  final _DashboardTab _tab;

  const _Chart(
      {Key key,
      @required List<ListData> data,
      @required charts.BarGroupingType groupingType,
      @required _DashboardTab tab})
      : assert(data != null),
        _data = data,
        _groupingType = groupingType,
        _tab = tab,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FutureBuilder(
          future: _series,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return Container(
              width: 400,
              height: 300,
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 300,
                    width: ((snapshot.data[0].data as List).length * 20).toDouble(),
                    child: charts.BarChart(
                      snapshot.data,
                      animate: false,
                      barGroupingType: _groupingType,
                      // vertical: false,
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                          desiredMinTickCount: 7,
                          desiredMaxTickCount: 13,
                        ),
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          // labelRotation: 90,
                          lineStyle: chartAxisLineStyle,
                        ),
                      ),
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: chartAxisTextStyle,
                          labelOffsetFromAxisPx: 45,
                          // labelOffsetFromTickPx: 40,
                          // labelJustification: charts.TickLabelJustification.inside,
                          labelAnchor: charts.TickLabelAnchor.after,
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
              ),
            );
          },
        ),
        SizedBox(height: 30), //delimiter
        // generateTitleTable(context)
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final data = List<BarChartData>();
      data.addAll(_data.map((it) {
        switch (_tab) {
          case _DashboardTab.cumulative:
            return BarChartData(
              it.title,
              it.values[0],
              HexColor.fromStringHash(it.title),
            );
          case _DashboardTab.evaluated:
            return BarChartData(
              it.title,
              it.values[1],
              HexColor.fromStringHash(it.title),
            );
        }
      }).toList());
      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'spending_Data',
          data: data,
        )
      ];
    });
  }
}
