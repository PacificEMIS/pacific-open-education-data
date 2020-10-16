import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

import '../budget_data.dart';

class SpendingByDistrictComponent extends StatefulWidget {
  final List<DataSpendingByDistrict> data;
  final List<DataSpendingByDistrict> dataFiltered;

  const SpendingByDistrictComponent({
    Key key,
    @required this.data,
    @required this.dataFiltered,
  })  : assert(data != null && dataFiltered != null),
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
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            return tab.toString().substring(5).localized(context);
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.actualExpenditure:
              case _Tab.budget:
              case _Tab.actualRecurrentExpenditure:
              case _Tab.budgetRecurrentExpenditure:
              case _Tab.actualExpPerHead:
              case _Tab.enrolment:
                return _Chart(
                    data: widget.data,
                    dataFiltered: widget.dataFiltered,
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab);
              case _Tab.budgetExpPerHead:
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

enum _Tab {
  actualExpenditure,
  budget,
  actualRecurrentExpenditure,
  budgetRecurrentExpenditure,
  actualExpPerHead,
  budgetExpPerHead,
  enrolment
}

class _Chart extends StatelessWidget {
  final List<DataSpendingByDistrict> _data;
  final List<DataSpendingByDistrict> _dataFiltered;
  final charts.BarGroupingType _groupingType;
  final _Tab _tab;

  const _Chart({
    Key key,
    @required List<DataSpendingByDistrict> data,
    @required List<DataSpendingByDistrict> dataFiltered,
    @required charts.BarGroupingType groupingType,
    @required _Tab tab,
  })  : assert(data != null),
        _data = data,
        _dataFiltered = dataFiltered,
        _groupingType = groupingType,
        _tab = tab,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Color>>(
      future: _colorScheme,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final colorScheme = snapshot.data;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 328 / 248,
              child: FutureBuilder(
                future: _createSeries(colorScheme),
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
                        desiredMinTickCount: 5,
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
            _generateTitleTable(context, colorScheme),
          ],
        );
      },
    );
  }

  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = Map<String, Color>();
      final dataSortedByDistrict = _dataFiltered.groupBy((it) => it.district);
      final districts = dataSortedByDistrict.keys.toList();
      districts.forEachIndexed((index, item) {
        colorScheme[item] = index < AppColors.kDistricts.length
            ? AppColors.kDistricts[index]
            : HexColor.fromStringHash(item);
      });
      return colorScheme;
    });
  }

  Widget _generateTitleTable(
    BuildContext context,
    Map<String, Color> colorScheme,
  ) {
    Map<String, int> districts = new Map();
    final dataSortedByDistrict = _dataFiltered.groupBy((it) => it.district);
    dataSortedByDistrict.forEach((key, value) {
      var spending = 0;
      var title = key;
      value.forEach((it) {
        if (_tab == _Tab.actualExpenditure)
          spending += it.edExpA;
        else if (_tab == _Tab.actualExpPerHead)
          spending += it.edExpAPerHead;
        else if (_tab == _Tab.actualRecurrentExpenditure)
          spending += it.edRecurrentExpA;
        else if (_tab == _Tab.budget)
          spending += it.edExpB;
        else if (_tab == _Tab.budgetExpPerHead)
          spending += it.edExpBPerHead;
        else if (_tab == _Tab.budgetRecurrentExpenditure)
          spending += it.edRecurrentExpB;
        else if (_tab == _Tab.enrolment) spending += it.enrolment;
      });
      if (spending != 0) districts[title] = spending;
    });

    if (districts.length == 0) return Container();

    final chartData = districts.mapToList((domain, measure) {
      return ChartData(
        domain,
        measure,
        colorScheme[domain],
      );
    });
    return ChartInfoTableWidget(
      chartData,
      'schoolsAccreditationDashboardsStateDomain'.localized(context),
      'enrolment'.localized(context),
    );
  }

  Future<List<charts.Series<ChartData, String>>> _createSeries(
    Map<String, Color> colorScheme,
  ) {
    return Future.microtask(() {
      final data = List<ChartData>();
      data.addAll(_data.map((it) {
        switch (_tab) {
          case _Tab.actualExpPerHead:
            return ChartData(
              it.year,
              it.edExpAPerHead,
              colorScheme[it.district],
            );
          case _Tab.actualExpenditure:
            return ChartData(
              it.year,
              it.edExpA,
              colorScheme[it.district],
            );
          case _Tab.actualRecurrentExpenditure:
            return ChartData(
              it.year,
              it.edRecurrentExpA,
              colorScheme[it.district],
            );
          //Budget
          case _Tab.budget:
            return ChartData(
              it.year,
              it.edExpB,
              colorScheme[it.district],
            );
          case _Tab.budgetExpPerHead:
            return ChartData(
              it.year,
              it.edExpBPerHead,
              colorScheme[it.district],
            );
          case _Tab.budgetRecurrentExpenditure:
            return ChartData(
              it.year,
              it.edRecurrentExpB,
              colorScheme[it.district],
            );
          case _Tab.enrolment:
            return ChartData(
              it.year,
              it.enrolment,
              colorScheme[it.district],
            );
        }
      }).toList());
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
}
