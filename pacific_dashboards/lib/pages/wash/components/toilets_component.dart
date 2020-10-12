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

class ToiletsComponent extends StatefulWidget {
  final List<ListData> data;
  final String year;

  const ToiletsComponent({
    Key key,
    @required this.data,
    @required this.year,
  })  : assert(data != null),
        assert(year != null),
        super(key: key);

  @override
  _ToiletsComponentState createState() => _ToiletsComponentState();
}

class _ToiletsComponentState extends State<ToiletsComponent> {
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
              case _DashboardTab.toiletsTotal:
                return 'wastToiletsTotal'.localized(context);
              case _DashboardTab.toiletsUsable:
                return 'washUsableToilets'.localized(context);
              case _DashboardTab.toiletsUsablePercentage:
                return 'washUsablePercentage'.localized(context);
              case _DashboardTab.toiletsUsablePercentageGender:
                return 'washUsableGenderToilets'.localized(context);
              case _DashboardTab.toiletsPupils:
                return 'washPupilsToilet'.localized(context);
              case _DashboardTab.toiletsPupilsGender:
                return 'washPupilsToiletGender'.localized(context);
              case _DashboardTab.toiletsPupilsUsableToilet:
                return 'washPupilsUsableToilet'.localized(context);
              case _DashboardTab.toiletsPupilsUsableToiletGender:
                return 'washPupilsUsableToiletGender'.localized(context);
              case _DashboardTab.pupils:
                return 'washPupils'.localized(context);
              case _DashboardTab.pupilsMirrorFormat:
                return 'washPupilsMirrorFormat'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _DashboardTab.toiletsTotal:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsUsable:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsUsablePercentage:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsUsablePercentageGender:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsPupils:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsPupilsGender:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsPupilsUsableToilet:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.toiletsPupilsUsableToiletGender:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.pupils:
                return _Chart(
                    year: widget.year,
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.pupilsMirrorFormat:
                return _Chart(
                    year: widget.year,
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
  toiletsTotal,
  toiletsUsable,
  toiletsUsablePercentage,
  toiletsUsablePercentageGender,
  toiletsPupils,
  toiletsPupilsGender,
  toiletsPupilsUsableToilet,
  toiletsPupilsUsableToiletGender,
  pupils,
  pupilsMirrorFormat
}

class _Chart extends StatelessWidget {
  final String _year;
  final List<ListData> _data;
  final charts.BarGroupingType _groupingType;
  final _DashboardTab _tab;

  const _Chart(
      {Key key,
      @required String year,
      @required bool showAllData,
      @required List<ListData> data,
      @required charts.BarGroupingType groupingType,
      @required _DashboardTab tab})
      : assert(data != null),
        _year = year,
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
                          labelOffsetFromAxisPx: 10,
                          labelOffsetFromTickPx: -5,
                          labelAnchor: charts.TickLabelAnchor.before,
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
          case _DashboardTab.toiletsTotal:
            return BarChartData(
              it.title,
              it.values[0] > 0 ? it.values[0] : 0.1,
              it.values[0] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsUsable:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsUsablePercentage:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsUsablePercentageGender:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsPupils:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsPupilsGender:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsPupilsUsableToilet:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.toiletsPupilsUsableToiletGender:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.pupils:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
            );
          case _DashboardTab.pupilsMirrorFormat:
            return BarChartData(
              it.title,
              it.values[1] > 0 ? it.values[1] : 0.1,
              it.values[1] > 0 ? HexColor.fromStringHash(it.title) : Colors.blue,
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
