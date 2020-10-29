import 'package:arch/arch.dart' show Pair;
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/wash/components/toilets/toilets_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

class ToiletsComponent extends StatelessWidget {
  final WashToiletViewData _data;

  const ToiletsComponent({
    Key key,
    @required WashToiletViewData data,
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
          tabs: _Tabs.values,
          tabNameBuilder: (tab) {
            return (tab as _Tabs).getLocalizedName(context);
          },
          builder: (context, tab) => _buildChartForTab(context, tab as _Tabs),
        ),
      ],
    );
  }

  Widget _buildChartForTab(BuildContext context, _Tabs tab) {
    switch (tab) {
      case _Tabs.totalToilets:
        return _DistrictDataByToiletTypeChart(data: _data.totalToilets);
      case _Tabs.usableToilets:
        return _DistrictDataByToiletTypeChart(data: _data.usableToilets);
      case _Tabs.usablePercent:
        return _DistrictDataByPercentChart(data: _data.usablePercent);
      case _Tabs.usablePercentByGender:
        return _DistrictDataByGenderPercentChart(
          data: _data.usablePercentByGender,
        );
      case _Tabs.pupilsByToilet:
        return _DistrictDataByPupilsChart(data: _data.pupilsByToilet);
      case _Tabs.pupilsByToiletByGender:
        return _DistrictDataByGenderChart(data: _data.pupilsByToiletByGender);
      case _Tabs.pupilsByUsableToilet:
        return _DistrictDataByPupilsChart(data: _data.pupilsByUsableToilet);
      case _Tabs.pupilsByUsableToiletByGender:
        return _DistrictDataByGenderChart(
          data: _data.pupilsByUsableToiletByGender,
        );
      case _Tabs.pupils:
        return _DistrictDataByGenderChart(data: _data.pupils);
      case _Tabs.pupilsMirrored:
        return _DistrictDataByGenderChart(data: _data.pupils);
    }
    throw FallThroughError();
  }
}

enum _Tabs {
  totalToilets,
  usableToilets,
  usablePercent,
  usablePercentByGender,
  pupilsByToilet,
  pupilsByToiletByGender,
  pupilsByUsableToilet,
  pupilsByUsableToiletByGender,
  pupils,
  pupilsMirrored,
}

extension _TabsNameExt on _Tabs {
  String getLocalizedName(BuildContext context) {
    switch (this) {
      case _Tabs.totalToilets:
        return 'washToiletsTotalToiletsTab'.localized(context);
      case _Tabs.usableToilets:
        return 'washToiletsUsableToiletsTab'.localized(context);
      case _Tabs.usablePercent:
        return 'washToiletsUsablePercentTab'.localized(context);
      case _Tabs.usablePercentByGender:
        return 'washToiletsUsablePercentByGenderTab'.localized(context);
      case _Tabs.pupilsByToilet:
        return 'washToiletsPupilsByToiletTab'.localized(context);
      case _Tabs.pupilsByToiletByGender:
        return 'washToiletsPupilsByToiletByGenderTab'.localized(context);
      case _Tabs.pupilsByUsableToilet:
        return 'washToiletsPupilsByUsableToiletTab'.localized(context);
      case _Tabs.pupilsByUsableToiletByGender:
        return 'washToiletsPupilsByUsableToiletByGenderTab'.localized(context);
      case _Tabs.pupils:
        return 'washToiletsPupilsTab'.localized(context);
      case _Tabs.pupilsMirrored:
        return 'washToiletsPupilsMirroredTab'.localized(context);
    }
    throw FallThroughError();
  }
}

class _DistrictDataByToiletTypeChart extends _Chart {
  final List<SchoolDataByToiletType> _data;

  const _DistrictDataByToiletTypeChart({
    Key key,
    @required List<SchoolDataByToiletType> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  List<ChartData> get chartData {
    final chartData = <ChartData>[];
    _data.forEach((it) {
      chartData.add(ChartData(
        it.school,
        it.boys,
        AppColors.kMale,
      ));
      chartData.add(ChartData(
        it.school,
        it.girls,
        AppColors.kFemale,
      ));
      chartData.add(ChartData(
        it.school,
        it.common,
        AppColors.kGreen,
      ));
    });
    return chartData;
  }

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('washToiletsBoysLabel', AppColors.kMale),
        Pair('washToiletsGirlsLabel', AppColors.kFemale),
        Pair('washToiletsCommonLabel', AppColors.kGreen),
      ];
}

class _DistrictDataByPercentChart extends _Chart {
  final List<SchoolDataByPercent> _data;

  const _DistrictDataByPercentChart({
    Key key,
    @required List<SchoolDataByPercent> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  List<ChartData> get chartData {
    final chartData = <ChartData>[];
    _data.forEach((it) {
      chartData.add(ChartData(
        it.school,
        it.percent,
        AppColors.kPercent,
      ));
    });
    return chartData;
  }

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('washToiletsUsablePercentLabel', AppColors.kPercent),
      ];
}

class _DistrictDataByGenderPercentChart extends _Chart {
  final List<SchoolDataByGenderPercent> _data;

  const _DistrictDataByGenderPercentChart({
    Key key,
    @required List<SchoolDataByGenderPercent> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  List<ChartData> get chartData {
    final chartData = <ChartData>[];
    _data.forEach((it) {
      chartData.add(ChartData(
        it.school,
        it.percentMale,
        AppColors.kMale,
      ));
      chartData.add(ChartData(
        it.school,
        -it.percentFemale,
        AppColors.kFemale,
      ));
    });
    return chartData;
  }

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('washToiletsBoysLabel', AppColors.kMale),
        Pair('washToiletsGirlsLabel', AppColors.kFemale),
      ];
}

class _DistrictDataByPupilsChart extends _Chart {
  final List<SchoolDataByPupils> _data;

  const _DistrictDataByPupilsChart({
    Key key,
    @required List<SchoolDataByPupils> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  List<ChartData> get chartData {
    final chartData = <ChartData>[];
    _data.forEach((it) {
      chartData.add(ChartData(
        it.school,
        it.pupils,
        AppColors.kPupil,
      ));
    });
    return chartData;
  }

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('washToiletsPupilsLabel', AppColors.kPupil),
      ];
}

class _DistrictDataByGenderChart extends _Chart {
  final List<SchoolDataByGender> _data;
  final bool _isMirrored;

  const _DistrictDataByGenderChart({
    Key key,
    @required List<SchoolDataByGender> data,
    bool isMirrored = false,
  })  : assert(data != null),
        assert(isMirrored != null),
        _data = data,
        _isMirrored = isMirrored,
        super(key: key);

  @override
  List<ChartData> get chartData {
    final chartData = <ChartData>[];
    _data.forEach((it) {
      chartData.add(ChartData(
        it.school,
        it.male,
        AppColors.kMale,
      ));
      chartData.add(ChartData(
        it.school,
        it.female * (_isMirrored ? -1 : 1),
        AppColors.kFemale,
      ));
    });
    return chartData;
  }

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => [
        Pair('labelMale', AppColors.kMale),
        Pair('labelFemale', AppColors.kFemale),
      ];
}

abstract class _Chart extends StatelessWidget {
  const _Chart({
    Key key,
  }) : super(key: key);

  @protected
  List<ChartData> get chartData;

  @protected
  int get domainLength;

  @protected
  List<Pair<String, Color>> get legend;

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

              return Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Container(
                    width: domainLength * 32.0,
                    child: charts.BarChart(
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
                          labelOffsetFromTickPx: -5,
                          labelOffsetFromAxisPx: 10,
                          labelAnchor: charts.TickLabelAnchor.before,
                          labelRotation: 270,
                          lineStyle: chartAxisLineStyle,
                        ),
                      ),
                      defaultRenderer: charts.BarRendererConfig(
                        stackHorizontalSeparator: 0,
                        minBarLengthPx: 30,
                        groupingType: charts.BarGroupingType.stacked,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(height: 6),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: legend.map((legendItem) {
            return ChartLegendItem(
              color: legendItem.second,
              value: legendItem.first.localized(context),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'data',
          data: chartData,
        )
      ];
    });
  }
}
