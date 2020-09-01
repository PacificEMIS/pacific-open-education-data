import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';
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
                    tab: tab);
              case _Tab.disability:
                return _Chart(
                    data: widget.data['disability'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab);
              case _Tab.ethnicity:
                return _Chart(
                    data: widget.data['ethnicity'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab);
              case _Tab.englishLearner:
                return _Chart(
                    data: widget.data['englishLearner'],
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab);
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

List<Widget> getColumnTitles(Map<String, List<DataByGroup>> data) {
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
            color: HexColor.fromStringHash(it), value: it == null ? 'na' : it),
      );
    });
  }
  return list;
}

enum _Tab { environment, disability, ethnicity, englishLearner }

class _Chart extends StatelessWidget {
  final Map<String, List<DataByGroup>> _data;
  final charts.BarGroupingType _groupingType;
  final _Tab _tab;
  const _Chart(
      {Key key,
      @required Map<String, List<DataByGroup>> data,
      @required charts.BarGroupingType groupingType,
      @required _Tab tab})
      : assert(data != null),
        _data = data,
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
            children: getColumnTitles(_data))
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final barChartData = List<BarChartData>();
      _data.forEach((key, value) {
        barChartData.addAll(value.map((it) {
          return BarChartData(
            it.title,
            it.firstValue,
            HexColor.fromStringHash(key),
          );
        }).toList());
      });
      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'cohort_distribution_Data',
          data: barChartData,
        )
      ];
    });
  }
}
