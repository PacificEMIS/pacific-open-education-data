import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/pages/special_education/special_education_data.dart';

class CohortDistributionComponent extends StatefulWidget {
  const CohortDistributionComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  final DataByCohortDistribution data;

  @override
  _CohortDistributionComponentState createState() =>
      _CohortDistributionComponentState();
}

class _CohortDistributionComponentState
    extends State<CohortDistributionComponent> {
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
                return 'specialEducationTabNameEnglishLearner'
                    .localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.environment:
                return _Chart(
                  data: widget.data.environment,
                );
              case _Tab.disability:
                return _Chart(
                  data: widget.data.disability,
                );
              case _Tab.ethnicity:
                return _Chart(
                  data: widget.data.etnicity,
                );
              case _Tab.englishLearner:
                return _Chart(
                  data: widget.data.englishLearner,
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
  const _Chart({
    Key key,
    @required List<DataByCohort> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  final List<DataByCohort> _data;

  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = <String, Color>{};
      _data.map((e) => e.cohortName)
        ..forEachIndexed((index, item) {
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
        final uniqueDomainsCount = _data
            .expand((e) => e.groupDataList)
            .uniques((it) => it.title)
            .length;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height:
                  uniqueDomainsCount * (uniqueDomainsCount > 5 ? 40.5 : 80.5),
              child: FutureBuilder(
                future: _createSeries(context, colorScheme),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return charts.BarChart(
                    snapshot.data,
                    animate: false,
                    vertical: false,
                    barGroupingType: charts.BarGroupingType.stacked,
                    primaryMeasureAxis: charts.NumericAxisSpec(
                      tickProviderSpec:
                          const charts.BasicNumericTickProviderSpec(
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: colorScheme.mapToList((legendItem, color) {
                return ChartLegendItem(
                  color: color,
                  value: legendItem.localized(context),
                );
              }),
            )
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
      final barChartData = <ChartData>[];

      for (final cohortData in _data) {
        barChartData.addAll(
          cohortData.groupDataList.map((it) {
            return ChartData(
              it.title.localized(context),
              it.firstValue,
              colorScheme[cohortData.cohortName],
            );
          }).toList(),
        );
      }

      return [
        charts.Series(
          domainFn: (chartData, _) => chartData.domain,
          measureFn: (chartData, _) => chartData.measure,
          colorFn: (chartData, _) => chartData.color.chartsColor,
          id: 'cohort_distribution_Data',
          data: barChartData,
        )
      ];
    });
  }
}
