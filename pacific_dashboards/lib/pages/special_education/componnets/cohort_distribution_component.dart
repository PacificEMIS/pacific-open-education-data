import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import '../special_education_data.dart';

class CohortDistributionComponent extends StatefulWidget {
  final Map<String, Map<String, List<DataByGroup>>> data;

  const CohortDistributionComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

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
                return 'environment'.localized(context);
              case _Tab.disability:
                return 'disability'.localized(context);
              case _Tab.ethnicity:
                return 'ethnicity'.localized(context);
              case _Tab.englishLearner:
                return 'englishLearner'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.environment:
                return _Chart(
                    data: widget.data['environment'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab,
                    chartHeight: widget.data.length);
              case _Tab.disability:
                return _Chart(
                    data: widget.data['disability'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab, chartHeight: widget.data.length);
              case _Tab.ethnicity:
                return _Chart(
                    data: widget.data['ethnicity'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab, chartHeight: widget.data.length);
              case _Tab.englishLearner:
                return _Chart(
                    data: widget.data['englishLearner'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab, chartHeight: widget.data.length);
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
  final Map<String, List<DataByGroup>> _data;
  final charts.BarGroupingType _groupingType;
  final int _chartHeight;

  const _Chart({
    Key key,
    @required Map<String, List<DataByGroup>> data,
    @required charts.BarGroupingType groupingType,
    @required _Tab tab,
    @required int chartHeight
  })  : assert(data != null),
        _data = data,
        _groupingType = groupingType,
        _chartHeight = chartHeight,
      super(key: key);

  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = Map<String, Color>();
      final domains = _data.keys.toList();
      domains.forEachIndexed((index, item) {
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: _chartHeight * (_chartHeight > 5 ? 40.5 : 80.5),
              child: FutureBuilder(
                future: _createSeries(colorScheme),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return charts.BarChart(
                    snapshot.data,
                    animate: false,
                    vertical: false,
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getColumnTitles(_data, colorScheme),
            )
          ],
        );
      },
    );
  }

  List<Widget> _getColumnTitles(
    Map<String, List<DataByGroup>> data,
    Map<String, Color> colorScheme,
  ) {
    List<Widget> list = new List<Widget>();
    List<String> titles = new List<String>();
    data.forEach((key, value) {
      titles.add(key);
    });
    titles = titles.toSet().toList();
    if (titles.length > 0) {
      titles.forEach((it) {
        list.add(
          ChartLegendItem(
              color: colorScheme[it] ?? Colors.bluex, value: it == null || it == '' ? 'na' : it),
        );
      });
    }
    return list;
  }

  Future<List<charts.Series<ChartData, String>>> _createSeries(
    Map<String, Color> colorScheme,
  ) {
    return Future.microtask(() {
      final barChartData = List<ChartData>();
      _data.forEach((key, value) {
        barChartData.addAll(value.map((it) {
          return ChartData(
            it.title,
            it.firstValue,
            colorScheme[key ?? 'na'],
          );
        }).toList());
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
