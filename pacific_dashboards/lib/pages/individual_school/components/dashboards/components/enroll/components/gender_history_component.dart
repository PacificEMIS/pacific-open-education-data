import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GenderHistoryComponent extends StatefulWidget {
  final List<EnrollDataByYear> data;

  const GenderHistoryComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _GenderHistoryComponentState createState() => _GenderHistoryComponentState();
}

class _GenderHistoryComponentState extends State<GenderHistoryComponent> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'individualSchoolDashboardEnrollByGenderHistoryTitle'
                .localized(context),
            style: textTheme.individualDashboardsSubtitle,
          ),
        ),
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _Tab.stacked:
                return 'individualSchoolDashboardEnrollByGradeLevelGenderHistoryStacked'
                    .localized(context);
              case _Tab.unstacked:
                return 'individualSchoolDashboardEnrollByGradeLevelGenderHistoryUnstacked'
                    .localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.stacked:
                return _StackedChart(data: widget.data);
              case _Tab.unstacked:
                return _UnstackedChart(data: widget.data);
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

enum _Tab { stacked, unstacked }

class _StackedChart extends StatelessWidget {
  final List<EnrollDataByYear> _data;

  const _StackedChart({
    Key key,
    @required List<EnrollDataByYear> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 328 / 198,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return charts.OrdinalComboChart(
                snapshot.data,
                animate: false,
                defaultRenderer: charts.LineRendererConfig(
                  includeArea: true,
                  stacked: true,
                ),
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
              value: 'labelMale'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kRed,
              value: 'labelFemale'.localized(context),
            ),
          ],
        )
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final maleData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.male,
          AppColors.kBlue,
        );
      }).toList();
      final femaleData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.female,
          AppColors.kRed,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'femaledata',
          data: femaleData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'maledata',
          data: maleData,
        ),
      ];
    });
  }
}

class _UnstackedChart extends StatelessWidget {
  final List<EnrollDataByYear> _data;

  const _UnstackedChart({
    Key key,
    @required List<EnrollDataByYear> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 328 / 198,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return charts.OrdinalComboChart(
                snapshot.data,
                animate: false,
                defaultRenderer: charts.LineRendererConfig(),
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
              value: 'labelMale'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kRed,
              value: 'labelFemale'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kGreen,
              value: 'labelTotal'.localized(context),
            ),
          ],
        )
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final maleData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.male,
          AppColors.kBlue,
        );
      }).toList();
      final femaleData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.female,
          AppColors.kRed,
        );
      }).toList();

      final totalData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.total,
          AppColors.kGreen,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'maledata',
          data: maleData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'femaledata',
          data: femaleData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'totaldata',
          data: totalData,
        ),
      ];
    });
  }
}
