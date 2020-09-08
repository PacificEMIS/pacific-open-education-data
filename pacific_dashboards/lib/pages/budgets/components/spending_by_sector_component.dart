import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

import '../budget_data.dart';

class SpendngBySectorComponent extends StatefulWidget {
  final Map<String, List<DataSpendingByYear>> data;

  const SpendngBySectorComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _SpendngBySectorComponentState createState() =>
      _SpendngBySectorComponentState();
}

class _SpendngBySectorComponentState extends State<SpendngBySectorComponent> {
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
              case _DashboardTab.actualExpPerHead:
                return 'actualExpPerHead'.localized(context);
              case _DashboardTab.actualExpenditure:
                return 'actualExpenditure'.localized(context);
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
                return _Chart(
                    data: widget.data['actualExpenditure'],
                    groupingType: charts.BarGroupingType.stacked);
              case _DashboardTab.budget:
                return _Chart(
                    data: widget.data['budgetExpenditure'],
                    groupingType: charts.BarGroupingType.stacked);
              case _DashboardTab.actualRecurrent:
                return _Chart(
                    data: widget.data['actualRecurrentExpenditure'],
                    groupingType: charts.BarGroupingType.stacked);
              case _DashboardTab.budgetRecurrent:
                return _Chart(
                    data: widget.data['budgetRecurrentExpenditure'],
                    groupingType: charts.BarGroupingType.stacked);
              case _DashboardTab.actualExpPerHead:
                return _Chart(
                    data: widget.data['actualExpPerHead'],
                    groupingType: charts.BarGroupingType.grouped);
              case _DashboardTab.budgetExpPerHead:
                return _Chart(
                    data: widget.data['budgetExpPerHead'],
                    groupingType: charts.BarGroupingType.grouped);
              case _DashboardTab.enrolment:
                return _Chart(
                    data: widget.data['enrolment'],
                    groupingType: charts.BarGroupingType.stacked);
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
  final List<DataSpendingByYear> _data;
  final charts.BarGroupingType _groupingType;
  const _Chart(
      {Key key,
      @required List<DataSpendingByYear> data,
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ChartLegendItem(
              color: AppColors.kBlue,
              value: 'labelEce'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kOrange,
              value: 'labelPrimary'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kYellow,
              value: 'labelSec'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final eceData = _data.map((it) {
        return BarChartData(
          it.year,
          it.ece,
          AppColors.kBlue,
        );
      }).toList();
      final primaryData = _data.map((it) {
        return BarChartData(
          it.year,
          it.primary,
          AppColors.kOrange,
        );
      }).toList();
      final secondaryData = _data.map((it) {
        return BarChartData(
          it.year,
          it.secondary,
          AppColors.kYellow,
        );
      }).toList();
      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'secondaryData',
          data: secondaryData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'primaryData',
          data: primaryData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'eceData',
          data: eceData,
        )
      ];
    });
  }
}
