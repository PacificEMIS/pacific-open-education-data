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

enum _Tab {
  actualExpenditure,
  budget,
  actualRecurrentExpenditure,
  budgetRecurrentExpenditure,
  actualExpPerHead,
  budgetExpPerHead,
  enrolment
}

extension _TabStringExt on _Tab {
  String getLocalizedName(BuildContext context) {
    switch (this) {
      case _Tab.actualExpenditure:
        return 'budgetsActualExpenditureTab'.localized(context);
      case _Tab.budget:
        return 'budgetsBudgetTab'.localized(context);
      case _Tab.actualRecurrentExpenditure:
        return 'budgetsActualRecurrentExpenditureTab'.localized(context);
      case _Tab.budgetRecurrentExpenditure:
        return 'budgetsBudgetedRecurrentExpenditureTab'.localized(context);
      case _Tab.actualExpPerHead:
        return 'budgetsActualExpPerHeadTab'.localized(context);
      case _Tab.budgetExpPerHead:
        return 'budgetsBudgetExpPerHeadTab'.localized(context);
      case _Tab.enrolment:
        return 'budgetsEnrollmentTab'.localized(context);
    }
    throw FallThroughError();
  }
}

class SpendingByDistrictComponent extends StatefulWidget {
  final List<DataSpendingByDistrict> data;
  final List<DataSpendingByDistrict> dataFiltered;
  final String domain;

  const SpendingByDistrictComponent({
    Key key,
    @required this.data,
    @required this.dataFiltered,
    @required this.domain,
  })  : assert(data != null),
        assert(dataFiltered != null),
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
            return (tab as _Tab).getLocalizedName(context);
          },
          builder: (context, tab) {
            return _Chart(
              data: widget.data,
              dataFiltered: widget.dataFiltered,
              groupingType: _getBarGroupingType(tab),
              tab: tab,
              domain: widget.domain,
            );
          },
        ),
      ],
    );
  }

  charts.BarGroupingType _getBarGroupingType(_Tab tab) {
    switch (tab) {
      case _Tab.actualExpenditure:
      case _Tab.budget:
      case _Tab.actualRecurrentExpenditure:
      case _Tab.budgetRecurrentExpenditure:
      case _Tab.actualExpPerHead:
      case _Tab.enrolment:
        return charts.BarGroupingType.stacked;
      case _Tab.budgetExpPerHead:
        return charts.BarGroupingType.groupedStacked;
    }
    throw FallThroughError();
  }
}

class _Chart extends StatelessWidget {
  final List<DataSpendingByDistrict> _data;
  final List<DataSpendingByDistrict> _dataFiltered;
  final charts.BarGroupingType _groupingType;
  final _Tab _tab;
  final String _domain;

  const _Chart({
    Key key,
    @required List<DataSpendingByDistrict> data,
    @required List<DataSpendingByDistrict> dataFiltered,
    @required charts.BarGroupingType groupingType,
    @required _Tab tab,
    @required String domain,
  })  : assert(data != null),
        _data = data,
        _dataFiltered = dataFiltered,
        _groupingType = groupingType,
        _tab = tab,
        _domain = domain,
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
            _generateTitleTable(context, colorScheme, _domain),
          ],
        );
      },
    );
  }

  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = Map<String, Color>();
      final dataSortedByDistrict = _data.groupBy((it) => it.district);
      final districts = dataSortedByDistrict.keys.toList();
      districts.forEachIndexed((index, item) {
        colorScheme[item] = index < AppColors.kDynamicPalette.length
            ? AppColors.kDynamicPalette[index]
            : HexColor.fromStringHash(item);
      });
      return colorScheme;
    });
  }

  Widget _generateTitleTable(
    BuildContext context,
    Map<String, Color> colorScheme,
    String domain,
  ) {
    final districts = Map<String, int>();
    _dataFiltered.groupBy((it) => it.district).forEach((district, value) {
      var spending = 0;
      value.forEach((it) {
        switch (_tab) {
          case _Tab.actualExpenditure:
            spending += it.edExpA;
            break;
          case _Tab.budget:
            spending += it.edExpB;
            break;
          case _Tab.actualRecurrentExpenditure:
            spending += it.edRecurrentExpA;
            break;
          case _Tab.budgetRecurrentExpenditure:
            spending += it.edRecurrentExpB;
            break;
          case _Tab.actualExpPerHead:
            spending += it.edExpAPerHead;
            break;
          case _Tab.budgetExpPerHead:
            spending += it.edExpBPerHead;
            break;
          case _Tab.enrolment:
            spending += it.enrolment;
            break;
        }
      });
      districts[district] = spending;
    });

    if (districts.length == 0) return Container();

    final chartData = districts.mapToList((domain, measure) {
      return ChartData(
        domain,
        measure ?? 0,
        colorScheme[domain],
      );
    });
    return ChartInfoTableWidget(
      chartData,
      domain.localized(context),
      _tab.getLocalizedName(context),
    );
  }

  Future<List<charts.Series<ChartData, String>>> _createSeries(
    Map<String, Color> colorScheme,
  ) {
    return Future.microtask(() {
      num Function(DataSpendingByDistrict, _Tab) extractMeasure =
          (data, tab) {
        switch (tab) {
          case _Tab.actualExpenditure:
            return data.edExpA;
          case _Tab.budget:
            return data.edExpB;
          case _Tab.actualRecurrentExpenditure:
            return data.edRecurrentExpA;
          case _Tab.budgetRecurrentExpenditure:
            return data.edRecurrentExpB;
          case _Tab.actualExpPerHead:
            return data.edExpAPerHead;
          case _Tab.budgetExpPerHead:
            return data.edExpBPerHead;
          case _Tab.enrolment:
            return data.enrolment;
        }
        throw FallThroughError();
      };
      _data.sort((rv, lv) => rv.district.compareTo(lv.district));
      final data = _data.map((it) {
        return ChartData(
          it.year,
          extractMeasure(it, _tab),
          colorScheme[it.district],
        );
      }).toList();
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
