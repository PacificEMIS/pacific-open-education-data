import 'package:arch/arch.dart' show Pair;
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/horizontal_stacked_scrollable_bar_chart.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';

import 'water_data.dart';

class WaterComponent extends StatelessWidget {
  final WashWaterViewData _data;

  const WaterComponent({
    Key key,
    @required WashWaterViewData data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            return _getTabName(context, tab);
          },
          builder: (context, tab) {
            return _Chart(
              data: _getChartDataForTab(tab),
            );
          },
        ),
      ],
    );
  }

  String _getTabName(BuildContext context, _Tab tab) {
    switch (tab) {
      case _Tab.currentlyAvailable:
        return 'washWaterCurrentlyAvailableTab'.localized(context);
      case _Tab.usedForDrinking:
        return 'washWaterUsedForDrinkingTab'.localized(context);
    }
    throw FallThroughError();
  }

  List<WaterViewDataBySchool> _getChartDataForTab(_Tab tab) {
    switch (tab) {
      case _Tab.currentlyAvailable:
        return _data.available;
      case _Tab.usedForDrinking:
        return _data.usedForDrinking;
    }
    throw FallThroughError();
  }
}

enum _Tab {
  currentlyAvailable,
  usedForDrinking,
}

class _Chart extends HorizontalStackedScrollableBarChart {
  final List<WaterViewDataBySchool> _data;

  const _Chart({
    Key key,
    @required List<WaterViewDataBySchool> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  List<ChartData> get chartData => _data
      .expand((schoolData) => [
            if (schoolData.pipedWaterSupply > 0)
              ChartData(
                schoolData.school,
                schoolData.pipedWaterSupply,
                AppColors.kDynamicPalette[0],
              ),
            if (schoolData.protectedWell > 0)
              ChartData(
                schoolData.school,
                schoolData.protectedWell,
                AppColors.kDynamicPalette[1],
              ),
            if (schoolData.unprotectedWellSpring > 0)
              ChartData(
                schoolData.school,
                schoolData.unprotectedWellSpring,
                AppColors.kDynamicPalette[2],
              ),
            if (schoolData.rainwater > 0)
              ChartData(
                schoolData.school,
                schoolData.rainwater,
                AppColors.kDynamicPalette[3],
              ),
            if (schoolData.bottled > 0)
              ChartData(
                schoolData.school,
                schoolData.bottled,
                AppColors.kDynamicPalette[4],
              ),
            if (schoolData.tanker > 0)
              ChartData(
                schoolData.school,
                schoolData.tanker,
                AppColors.kDynamicPalette[5],
              ),
            if (schoolData.surfaced > 0)
              ChartData(
                schoolData.school,
                schoolData.surfaced,
                AppColors.kDynamicPalette[6],
              ),
          ])
      .toList();

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('washWaterLegendPipedWaterSupply', AppColors.kDynamicPalette[0]),
        Pair('washWaterLegendProtectedWell', AppColors.kDynamicPalette[1]),
        Pair('washWaterLegendUnprotectedWellSpring',
            AppColors.kDynamicPalette[2]),
        Pair('washWaterLegendRainwater', AppColors.kDynamicPalette[3]),
        Pair('washWaterLegendBottledWater', AppColors.kDynamicPalette[4]),
        Pair('washWaterLegendTanker', AppColors.kDynamicPalette[5]),
        Pair('washWaterLegendSurfacedWater', AppColors.kDynamicPalette[6]),
      ];
}
