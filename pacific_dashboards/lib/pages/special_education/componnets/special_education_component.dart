import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';
import '../special_education_data.dart';

class SpecialEducationComponent extends StatefulWidget {
  final List<DataByGroup> data;

  const SpecialEducationComponent({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _SpecialEducationComponentState createState() =>
      _SpecialEducationComponentState();
}

class _SpecialEducationComponentState extends State<SpecialEducationComponent> {
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
              case _Tab.schedule:
                return 'schedule'.localized(context);
              case _Tab.diagram:
                return 'diagram'.localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.schedule:
                return _Chart(
                    data: widget.data,
                    groupingType: charts.BarGroupingType.stacked,
                    tab: tab, chartHeight: widget.data.length);
              case _Tab.diagram:
                return ChartWithTable(
                  key: ObjectKey(widget.data),
                  title: '',
                  data: widget.data
                      .map(
                        (it) => ChartData(
                          it.title,
                          it.total,
                          HexColor.fromStringHash(it.title),
                        ),
                      )
                      .toList(),
                  chartType: ChartType.pie,
                  tableKeyName:
                      'teachersDashboardsAuthorityDomain'.localized(context),
                  tableValueName:
                      'individualSchoolDashboardEnrollTitle'.localized(context),
                );
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

enum _Tab {
  schedule,
  diagram,
}

class _Chart extends StatelessWidget {
  final List<DataByGroup> _data;
  final charts.BarGroupingType _groupingType;
  final _Tab _tab;
  final int _chartHeight;

  const _Chart(
      {Key key,
      @required List<DataByGroup> data,
      @required charts.BarGroupingType groupingType,
      @required _Tab tab, @required int chartHeight})
      : assert(data != null),
        _data = data,
        _groupingType = groupingType,
        _tab = tab,
        _chartHeight = chartHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
            FutureBuilder(
              future: _series,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (_tab == _Tab.diagram) {
                  return
                    SizedBox(height: _chartHeight * (_chartHeight > 5 ? 40.5 : 80.5), child: charts.PieChart(
                    snapshot.data,
                    animate: false,
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 100,
                      strokeWidthPx: 0.0,
                    ),
                    ),
                  );
                } else {
                  return
                    SizedBox(height: _chartHeight * (_chartHeight > 5 ? 40.5 : 80.5), child: charts.BarChart(
                    snapshot.data,
                    animate: false,
                    barGroupingType: _groupingType,
                    vertical: false,
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
                    ),
                  );
                }
              },
            ),
          if (_tab == _Tab.schedule)
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ChartLegendItem(
                    color: AppColors.kOrange,
                    value: 'labelMale'.localized(context),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ChartLegendItem(
                    color: AppColors.kBlue,
                    value: 'labelFemale'.localized(context),
                  )
                ])
        ]);
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      final barChartData = List<ChartData>();
      if (_tab.index == 0) {
        barChartData.addAll(_data.map((it) {
          var title = it.title.length > 15 ? it.title.replaceFirst(new RegExp(r'\s'), '\n', 15) : it.title;
          return ChartData(
            title,
            it.firstValue,
            AppColors.kBlue,
          );
        }).toList());
        barChartData.addAll(_data.map((it) {
          var title = it.title.length > 15 ? it.title.replaceFirst(new RegExp(r'\s'), '\n', 15) : it.title;
          return ChartData(
            title,
            it.secondValue,
            AppColors.kOrange,
          );
        }).toList());
      } else {
        barChartData.addAll(_data.map((it) {
          return ChartData(
            it.title,
            it.firstValue,
            HexColor.fromStringHash(it.title),
          );
        }).toList());
      }
      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'special_education_Data',
          data: barChartData,
        )
      ];
    });
  }
}
