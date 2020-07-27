import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/enroll_data_by_grade_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LevelAndGenderComponent extends StatefulWidget {
  final EnrollDataByGradeHistory data;

  const LevelAndGenderComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _LevelAndGenderComponentState createState() => _LevelAndGenderComponentState();
}

class _LevelAndGenderComponentState extends State<LevelAndGenderComponent> {
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
            '${AppLocalizations.individualSchoolEnrollByLevelAndGender} (${widget.data.year})',
            style: textTheme.headline4.copyWith(fontSize: 12),
          ),
        ),
        MiniTabLayout(
          tabs: _View.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _View.chart:
                return AppLocalizations
                    .individualSchoolEnrollByLevelAndGenderChart;
              case _View.table:
                return AppLocalizations
                    .individualSchoolEnrollByLevelAndGenderTable;
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _View.chart:
                return _Chart(data: widget.data.data);
              case _View.table:
                return EnrollDataByGradeComponent(data: widget.data.data);
            }
            throw FallThroughError();
          },
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

enum _View { chart, table }

class _Chart extends StatelessWidget {
  final List<EnrollDataByGrade> _data;

  const _Chart({
    Key key,
    @required List<EnrollDataByGrade> data,
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
          aspectRatio: 328 / 248,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final chartAxisTextStyle = charts.TextStyleSpec(
                fontSize: 10,
                color: AppColors.kTextMinor.chartsColor,
              );
              final chartAxisLineStyle = charts.LineStyleSpec(
                color: AppColors.kCoolGray.chartsColor,
              );

              return charts.BarChart(
                snapshot.data,
                animate: false,
                barGroupingType: charts.BarGroupingType.stacked,
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
              value: AppLocalizations.male,
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kRed,
              value: AppLocalizations.female,
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
          it.grade,
          it.male,
          AppColors.kBlue,
        );
      }).toList();
      final femaleData = _data.map((it) {
        return BarChartData(
          it.grade,
          it.female,
          AppColors.kRed,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: AppLocalizations.male,
          data: maleData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: AppLocalizations.female,
          data: femaleData,
        ),
      ];
    });
  }
}
