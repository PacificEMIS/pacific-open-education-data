import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

import '../wash_data.dart';

class TotalComponent extends StatefulWidget {
  final List<ListData> data;
  final String year;

  const TotalComponent({
    Key key,
    @required this.data,
    @required this.year,
  })  : assert(data != null),
        assert(year != null),
        super(key: key);

  @override
  _TotalComponentState createState() => _TotalComponentState();
}

class _TotalComponentState extends State<TotalComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length == 0) {
      return Center(
        child: Text(
          'labelNoData'.localized(context),
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MiniTabLayout(
          tabs: _DashboardTab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _DashboardTab.cumulative:
                return '${'washCumulative'.localized(context)} to ${widget.year}';
              case _DashboardTab.evaluated:
                return '${'washEvaluated'.localized(context)} in ${widget.year}';
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _DashboardTab.cumulative:
                return _Chart(
                    data: widget.data,
                    groupingType: charts.BarGroupingType.groupedStacked,
                    tab: tab);
              case _DashboardTab.evaluated:
                return _Chart(
                    data: widget.data,
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

enum _DashboardTab {
  cumulative,
  evaluated,
}

class _Chart extends StatelessWidget {
  final List<ListData> _data;
  final charts.BarGroupingType _groupingType;
  final _DashboardTab _tab;

  const _Chart(
      {Key key,
      @required List<ListData> data,
      @required charts.BarGroupingType groupingType,
      @required _DashboardTab tab})
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
        Container(
          height: 300,
          child: FutureBuilder(
            future: _series,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Container(
                child: charts.BarChart(
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
                      // labelRotation: 90,
                      lineStyle: chartAxisLineStyle,
                    ),
                  ),
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: chartAxisTextStyle,
                      labelOffsetFromAxisPx: 10,
                      labelOffsetFromTickPx: -5,
                      labelAnchor: charts.TickLabelAnchor.before,
                      labelRotation: 270,
                      lineStyle: chartAxisLineStyle,
                    ),
                  ),
                  defaultRenderer: charts.BarRendererConfig(
                    stackHorizontalSeparator: 0,
                    minBarLengthPx: 30,
                    groupingType: charts.BarGroupingType.stacked,
                    strokeWidthPx: 10,
                  ),
                ),
              );
            },
          ),
        ),
        // generateTitleTable(context)
      ],
    );
  }

  ChartInfoTableWidget generateTitleTable(BuildContext context) {
    Map<String, int> districts = new Map();
    final dataSortedByDistrict = _data.groupBy((it) => it.title);
    dataSortedByDistrict.forEach((key, value) {
      var spending = 0;
      value.forEach((it) {
        if (_tab == _DashboardTab.cumulative)
          spending += it.values[0];
        else if (_tab == _DashboardTab.evaluated) spending += it.values[1];
      });
      districts[key] = spending;
    });
    final chartData = districts.mapToList((domain, measure) {
      final domains = districts.keys.toList();
      final index = domains.indexOf(domain);
      final color = index < AppColors.kDistricts.length
          ? AppColors.kDistricts[index]
          : HexColor.fromStringHash(domain);
      return ChartData(
        domain,
        measure,
        color,
      );
    });
    return ChartInfoTableWidget(
      chartData,
      'district'.localized(context),
      'labelTotal'.localized(context),
    );
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      final data = List<ChartData>();
      data.addAll(_data.map((it) {
        switch (_tab) {
          case _DashboardTab.cumulative:
            return ChartData(
              it.title,
              it.values[0],
              HexColor.fromStringHash(it.title),
            );
          case _DashboardTab.evaluated:
            return ChartData(
              it.title,
              it.values[1],
              HexColor.fromStringHash(it.title),
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
