import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/enroll_data_by_grade_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

class LevelAndGenderComponent extends StatefulWidget {
  const LevelAndGenderComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  final EnrollDataByGradeHistory data;

  @override
  _LevelAndGenderComponentState createState() =>
      _LevelAndGenderComponentState();
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
            // ignore: lines_longer_than_80_chars
            '${'individualSchoolDashboardEnrollByGradeLevelGenderTitle'.localized(context)} '
            '${widget.data.year}',
            style: textTheme.headline4,
          ),
        ),
        MiniTabLayout(
          tabs: _View.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _View.chart:
                return 'individualSchoolDashboardEnrollByGradeLevelGenderChart'
                    .localized(context);
              case _View.table:
                return 'individualSchoolDashboardEnrollByGradeLevelGenderTable'
                    .localized(context);
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
      ],
    );
  }
}

enum _View { chart, table }

class _Chart extends StatelessWidget {
  const _Chart({
    Key key,
    @required List<EnrollDataByGrade> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  final List<EnrollDataByGrade> _data;

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
                barGroupingType: charts.BarGroupingType.stacked,
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickProviderSpec: const charts.BasicNumericTickProviderSpec(
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
            const SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kRed,
              value: 'labelFemale'.localized(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      final maleData = _data.map((it) {
        return ChartData(
          it.grade,
          it.male,
          AppColors.kBlue,
        );
      }).toList();
      final femaleData = _data.map((it) {
        return ChartData(
          it.grade,
          it.female,
          AppColors.kRed,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (chartData, _) => chartData.domain,
          measureFn: (chartData, _) => chartData.measure,
          colorFn: (chartData, _) => chartData.color.chartsColor,
          id: 'maledata',
          data: maleData,
        ),
        charts.Series(
          domainFn: (chartData, _) => chartData.domain,
          measureFn: (chartData, _) => chartData.measure,
          colorFn: (chartData, _) => chartData.color.chartsColor,
          id: 'femaledata',
          data: femaleData,
        ),
      ];
    });
  }
}
