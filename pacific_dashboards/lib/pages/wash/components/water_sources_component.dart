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
  final List<Wash> data;
  final List<Wash> dataFiltered;

  const WaterComponent({
    Key key,
    @required this.data,
    @required this.dataFiltered,
  })  : assert(data != null && dataFiltered != null),
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
          tabs: _DashboardTab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _DashboardTab.currentAvailable:
                return 'actualExpenditure'.localized(context);
              case _DashboardTab.usedForDrinking:
                return 'actualExpPerHead'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _DashboardTab.currentAvailable:
                return _Chart(
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.usedForDrinking:
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
  currentAvailable,
  usedForDrinking,
}

class _Chart extends StatelessWidget {
  final List<Wash> _data;
  final charts.BarGroupingType _groupingType;
  final _DashboardTab _tab;

  const _Chart(
      {Key key,
      @required List<Wash> data,
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
        AspectRatio(
          aspectRatio: 328 / 248,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return charts.BarChart(
                snapshot.data,
                animate: false,
                barGroupingType: _groupingType,
                vertical: false,
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
                    lineStyle: chartAxisLineStyle,
                  ),
                ),
              );
            },
          ),
        ),
        generateTitleTable(context)
      ],
    );
  }

  ChartInfoTableWidget generateTitleTable(BuildContext context) {
    Map<String, int> districts = new Map();
    final dataSortedByDistrict = _data.groupBy((it) => it.district);
    dataSortedByDistrict.forEach((key, value) {
      var spending = 0;
      value.forEach((it) {
        if (_tab == _DashboardTab.currentAvailable)
          spending += it.number;
        else if (_tab == _DashboardTab.usedForDrinking) spending += it.number;
      });
      districts[key] = spending;
    });
    return ChartInfoTableWidget(
        districts,
        'schoolsAccreditationDashboardsStateDomain'.localized(context),
        'enrolment'.localized(context));
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final data = List<BarChartData>();
      data.addAll(_data.map((it) {
//        switch (_tab) {
//          case _DashboardTab.currentAvailable:
//            return BarChartData(
//              it.year,
//              it.edExpAPerHead,
//              HexColor.fromStringHash(it.district),
//            );
//          case _DashboardTab.usedForDrinking:
//            return BarChartData(
//              it.year,
//              it.edExpA,
//              HexColor.fromStringHash(it.district),
//            );
//        }
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
