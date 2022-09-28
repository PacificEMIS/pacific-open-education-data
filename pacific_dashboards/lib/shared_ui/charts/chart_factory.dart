import 'package:flutter/material.dart';
import 'package:pacific_dashboards/shared_ui/charts/bar_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/pie_chart_widget.dart';
import 'package:pacific_dashboards/shared_ui/charts/stacked_horizontal_bar_chart_widget.dart';

import '../mini_tab_layout.dart';
import '../tables/chart_info_table_widget.dart';

class ChartFactory {
  static Widget createBarChartViewByData(
    List<ChartData> chartData,
  ) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 250.0,
            child: BarChartWidget(key: ObjectKey(chartData), data: chartData),
          );
  }

  static Widget createPieChartViewByData(
    List<ChartData> chartData,
  ) {
    return (chartData.length == 0)
        ? Container()
        : Container(
            height: 300.0,
            child: PieChartWidget(
              key: ObjectKey(chartData),
              data: chartData,
              animate: false,
            ),
          );
  }

  static Widget createChart(
    ChartType type,
    List<ChartData> data,
  ) {
    switch (type) {
      case ChartType.bar:
        return createBarChartViewByData(data);
      case ChartType.pie:
        return createPieChartViewByData(data);
      case ChartType.none:
        return Container();
    }
    throw FallThroughError();
  }

  static Widget createStackedHorizontalBarChartViewByData(
      {Map<String, List<int>> chartData, ColorFunc colorFunc}) {
    // final tableData = chartData != null && true
    //     ? chartData[selectedItem]
    //         .map((e) => ChartData('Level ${id}', e, colorFunc(id++)))
    //         .toList()
    //     : [];
    int ids = 0;

    return chartData.length == 0
        ? Container()
        : Column(children: [
            Container(
              height: 300.0,
              child: StackedHorizontalBarChartWidget(
                data: chartData,
                colorFunc: colorFunc,
              ),
            ),
            MiniTabLayout(
                tabs: chartData.keys.toList(),
                // padding: 0.0,
                tabNameBuilder: (tab) {
                  return tab;
                },
                builder: (ctx, tab) {
                  int id = 0;
                  List<ChartData> chartDataList = [];
                  chartData.values.elementAt(ids).map((e) {
                    chartDataList
                        .add(ChartData('Level ${id}', e, colorFunc(id++)));
                  }).toList();
                  ids++;
                  return ChartInfoTableWidget(
                      chartDataList, 'Level', 'Amount', true);
                })
          ]);
  }
}

enum ChartType { bar, pie, none }
