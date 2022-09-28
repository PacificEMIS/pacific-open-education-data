import 'package:arch/arch.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';

import '../special_education_data.dart';

class CohortDistributionComponent extends StatefulWidget {
  final DataByCohortDistribution data;

  const CohortDistributionComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _CohortDistributionComponentState createState() => _CohortDistributionComponentState();
}

class _CohortDistributionComponentState extends State<CohortDistributionComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _Tab.environment:
                return 'specialEducationTabNameEnvironment'.localized(context);
              case _Tab.disability:
                return 'specialEducationTabNameDisability'.localized(context);
              case _Tab.ethnicity:
                return 'specialEducationTabNameEthnicity'.localized(context);
              case _Tab.englishLearner:
                return 'specialEducationTabNameEnglishLearner'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.environment:
                return _Chart(
                  data: widget.data.environment,
                  tableName: 'specialEducationTabNameEnvironment',
                );
              case _Tab.disability:
                return _Chart(
                  data: widget.data.disability,
                  tableName: 'specialEducationTabNameDisability',
                );
              case _Tab.ethnicity:
                return _Chart(
                  data: widget.data.etnicity,
                  tableName: 'specialEducationTabNameEthnicity',
                );
              case _Tab.englishLearner:
                return _Chart(
                  data: widget.data.englishLearner,
                  tableName: 'specialEducationTabNameEnglishLearner',
                );
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

enum _Tab { environment, disability, ethnicity, englishLearner }

class _Chart extends StatelessWidget {
  final List<DataByCohort> _data;
  final String _tableName;

  const _Chart({
    Key key,
    @required List<DataByCohort> data,
    @required tableName,
  })  : assert(data != null),
        _data = data,
        _tableName = tableName,
        super(key: key);

  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = Map<String, Color>();
      final legends = _data.map((e) => e.cohortName);
      legends.forEachIndexed((index, item) {
        colorScheme[item] = index < AppColors.kDynamicPalette.length
            ? AppColors.kDynamicPalette[index]
            : HexColor.fromStringHash(item);
      });
      return colorScheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Color>>(
      future: _colorScheme,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final colorScheme = snapshot.data;
        final uniqueDomainsCount =
            _data.expand((e) => e.groupDataList).uniques((it) => it.title).length;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: uniqueDomainsCount * (uniqueDomainsCount > 5 ? 40.5 : 80.5),
              child: FutureBuilder(
                future: _createSeries(context, colorScheme),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return charts.BarChart(
                    snapshot.data,
                    animate: false,
                    defaultInteractions: false,
                    vertical: false,
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
            ChartWithTable(
              key: ObjectKey(_data),
              title: '',
              data: _data
                  .map((it) => ChartData(
                        it.cohortName.localized(context),
                        it.groupDataList.length,
                        colorScheme[it.cohortName],
                      ))
                  .toList(),
              chartType: ChartType.none,
              tableKeyName: _tableName.localized(context),
              tableValueName: 'specialEducationEnrollDomain'.localized(context),
              showColors: true,
            ),
          ],
        );
      },
    );
  }

  Future<List<charts.Series<ChartData, String>>> _createSeries(
    BuildContext context,
    Map<String, Color> colorScheme,
  ) {
    return Future.microtask(() {
      final barChartData = List<ChartData>();
      _data.forEach((cohortData) {
        barChartData.addAll(
          cohortData.groupDataList.map((it) {
            return ChartData(
              it.title.localized(context),
              it.firstValue,
              colorScheme[cohortData.cohortName],
            );
          }).toList(),
        );
      });
      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'cohort_distribution_Data',
          data: barChartData,
        )
      ];
    });
  }
}
