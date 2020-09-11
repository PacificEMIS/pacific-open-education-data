import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

import '../budget_data.dart';

class SpendingByDistrictComponent extends StatefulWidget {
  final List<DataSpendingByDistrict> data;
  final List<DataSpendingByDistrict> dataFiltered;
  final String year;

  const SpendingByDistrictComponent(
      {Key key, @required this.data,
        @required this.dataFiltered,
        @required this.year
      })
      : assert(data != null && dataFiltered != null),
        super(key: key);

  @override
  _SpendingByDistrictComponentState createState() =>
      _SpendingByDistrictComponentState();
}

class _SpendingByDistrictComponentState
    extends State<SpendingByDistrictComponent> {
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
              case _DashboardTab.actualExpenditure:
                return 'actualExpenditure'.localized(context);
              case _DashboardTab.actualExpPerHead:
                return 'actualExpPerHead'.localized(context);
              case _DashboardTab.actualRecurrent:
                return 'actualRecurrentExpenditure'.localized(context);
              case _DashboardTab.budget:
                return 'budgetExpenditure'.localized(context);
              case _DashboardTab.budgetExpPerHead:
                return 'budgetExpPerHead'.localized(context);
              case _DashboardTab.budgetRecurrent:
                return 'budgetRecurrentExpenditure'.localized(context);
              case _DashboardTab.enrolment:
                return 'enrolment'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _DashboardTab.actualExpenditure:
              case _DashboardTab.budget:
              case _DashboardTab.actualRecurrent:
              case _DashboardTab.budgetRecurrent:
              case _DashboardTab.actualExpPerHead:
              case _DashboardTab.enrolment:
                return _Chart(
                    data: widget.data,
                    dataFiltered: widget.dataFiltered,
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab);
              case _DashboardTab.budgetExpPerHead:
                return _Chart(
                    data: widget.data,
                    dataFiltered: widget.dataFiltered,
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
  actualExpenditure,
  budget,
  actualRecurrent,
  budgetRecurrent,
  actualExpPerHead,
  budgetExpPerHead,
  enrolment
}

class _Chart extends StatelessWidget {
  final List<DataSpendingByDistrict> _data;
  final List<DataSpendingByDistrict> _dataFiltered;
  final charts.BarGroupingType _groupingType;
  final _DashboardTab _tab;

  const _Chart(
      {Key key,
      @required List<DataSpendingByDistrict> data,
      @required List<DataSpendingByDistrict> dataFiltered,
      @required charts.BarGroupingType groupingType,
      @required _DashboardTab tab})
      : assert(data != null),
        _data = data,
        _dataFiltered = dataFiltered,
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
    final dataSortedByDistrict = _dataFiltered.groupBy((it) => it.district);
    dataSortedByDistrict.forEach((key, value) {
      var spending = 0;
      value.forEach((it) {
        if (_tab == _DashboardTab.actualExpenditure)
          spending += it.edExpA;
        else if (_tab == _DashboardTab.actualExpPerHead)
          spending += it.edExpAPerHead;
        else if (_tab == _DashboardTab.actualRecurrent)
          spending += it.edRecurrentExpA;
        else if (_tab == _DashboardTab.budget)
          spending += it.edExpB;
        else if (_tab == _DashboardTab.budgetExpPerHead)
          spending += it.edExpBPerHead;
        else if (_tab == _DashboardTab.budgetRecurrent)
          spending += it.edRecurrentExpB;
        else if (_tab == _DashboardTab.enrolment)
          spending += it.enrolment;
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
        switch (_tab) {
          case _DashboardTab.actualExpPerHead:
            return BarChartData(
              it.year,
              it.edExpAPerHead,
              HexColor.fromStringHash(it.district),
            );
          case _DashboardTab.actualExpenditure:
            return BarChartData(
              it.year,
              it.edExpA,
              HexColor.fromStringHash(it.district),
            );
          case _DashboardTab.actualRecurrent:
            return BarChartData(
              it.year,
              it.edRecurrentExpA,
              HexColor.fromStringHash(it.district),
            );
          //Budget
          case _DashboardTab.budget:
            return BarChartData(
              it.year,
              it.edExpB,
              HexColor.fromStringHash(it.district),
            );
          case _DashboardTab.budgetExpPerHead:
            return BarChartData(
              it.year,
              it.edExpBPerHead,
              HexColor.fromStringHash(it.district),
            );
          case _DashboardTab.budgetRecurrent:
            return BarChartData(
              it.year,
              it.edRecurrentExpB,
              HexColor.fromStringHash(it.district),
            );
          case _DashboardTab.enrolment:
            return BarChartData(
              it.year,
              it.enrolment,
              HexColor.fromStringHash(it.district),
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
