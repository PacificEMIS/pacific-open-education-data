import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FemalePartComponent extends StatefulWidget {
  final EnrollData data;
  final int year;
  final String schoolId;
  final String district;

  const FemalePartComponent({
    Key key,
    @required this.year,
    @required this.data,
    @required this.schoolId,
    @required this.district,
  })  : assert(data != null),
        assert(schoolId != null),
        assert(district != null),
        super(key: key);

  @override
  _FemalePartComponentState createState() => _FemalePartComponentState();
}

class _FemalePartComponentState extends State<FemalePartComponent> {
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
            '${'individualSchoolDashboardEnrollFemalePartTitle'.localized(context)} ${widget.year}',
            style: textTheme.headline4,
          ),
        ),
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _Tab.detailed:
                return '${widget.data.femalePartOnLastYear.year}'
                    '${'individualSchoolDashboardEnrollFemalePartDetailed'.localized(context)}';
              case _Tab.history:
                return 'individualSchoolDashboardEnrollFemalePartHistory'
                    .localized(context);
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.detailed:
                return _DetailedChart(
                  data: widget.data.femalePartOnLastYear.data,
                  schoolId: widget.schoolId,
                  district: widget.district,
                );
              case _Tab.history:
                return _HistoryChart(
                  data: widget.data.femalePartHistory,
                  schoolId: widget.schoolId,
                  district: widget.district,
                );
            }
            throw FallThroughError();
          },
        ),
      ],
    );
  }
}

enum _Tab { detailed, history }

class _DetailedChart extends StatelessWidget {
  final List<EnrollDataByFemalePart> _data;
  final String schoolId;
  final String district;

  const _DetailedChart({
    Key key,
    @required List<EnrollDataByFemalePart> data,
    @required this.schoolId,
    @required this.district,
  })  : assert(data != null),
        assert(schoolId != null),
        assert(district != null),
        _data = data,
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
                barGroupingType: charts.BarGroupingType.grouped,
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ChartLegendItem(
              color: AppColors.kPeacockBlue,
              value: schoolId,
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kGreen,
              value: district,
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kOrange,
              value: 'labelNational'.localized(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final schoolData = _data.map((it) {
        return BarChartData(
          it.grade,
          it.school,
          AppColors.kPeacockBlue,
        );
      }).toList();

      final districtData = _data.map((it) {
        return BarChartData(
          it.grade,
          it.district,
          AppColors.kGreen,
        );
      }).toList();

      final nationData = _data.map((it) {
        return BarChartData(
          it.grade,
          it.nation,
          AppColors.kOrange,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'school',
          data: schoolData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'district',
          data: districtData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'nation',
          data: nationData,
        ),
      ];
    });
  }
}

class _HistoryChart extends StatelessWidget {
  final List<EnrollDataByFemalePartHistory> _data;
  final String schoolId;
  final String district;

  const _HistoryChart({
    Key key,
    @required List<EnrollDataByFemalePartHistory> data,
    @required this.schoolId,
    @required this.district,
  })  : assert(data != null),
        assert(schoolId != null),
        assert(district != null),
        _data = data,
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

              return charts.OrdinalComboChart(
                snapshot.data,
                animate: false,
                defaultRenderer: charts.LineRendererConfig(),
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ChartLegendItem(
              color: AppColors.kPeacockBlue,
              value: schoolId,
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kGreen,
              value: district,
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kOrange,
              value: 'labelNational'.localized(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final schoolData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.school,
          AppColors.kPeacockBlue,
        );
      }).toList();

      final districtData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.district,
          AppColors.kGreen,
        );
      }).toList();

      final nationData = _data.map((it) {
        return BarChartData(
          '${it.year}',
          it.nation,
          AppColors.kOrange,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'school',
          data: schoolData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'district',
          data: districtData,
        ),
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'nation',
          data: nationData,
        ),
      ];
    });
  }
}
