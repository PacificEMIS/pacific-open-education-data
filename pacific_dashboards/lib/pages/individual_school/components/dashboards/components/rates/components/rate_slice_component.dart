import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;

typedef ClassLevelRateAccessor = double Function(ClassLevelRatesData data);
typedef YearRateAccessor = double Function(YearRateData data);

class RateSliceComponent extends StatelessWidget {
  final RatesData _ratesData;
  final ClassLevelRateAccessor _classLevelRateAccessor;
  final YearRateAccessor _yearRateAccessor;
  final String _title;

  const RateSliceComponent({
    Key key,
    @required String title,
    @required RatesData ratesData,
    @required ClassLevelRateAccessor classLevelRateAccessor,
    @required YearRateAccessor yearRateAccessor,
  })  : assert(title != null),
        assert(ratesData != null),
        assert(classLevelRateAccessor != null),
        assert(yearRateAccessor != null),
        _title = title,
        _ratesData = ratesData,
        _classLevelRateAccessor = classLevelRateAccessor,
        _yearRateAccessor = yearRateAccessor,
        super(key: key);

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
            _title,
            style: textTheme.individualDashboardsSubtitle,
          ),
        ),
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _Tab.lastYearDetailed:
                return '${_ratesData.lastYearRatesData.year}${AppLocalizations.individualSchoolFlowDetailed}';
              case _Tab.historyChart:
                return AppLocalizations.individualSchoolFlowHistoryChart;
              case _Tab.historyTable:
                return AppLocalizations.individualSchoolFlowHistoryTable;
            }
            throw FallThroughError();
          },
          builder: (ctx, tab) {
            switch (tab) {
              case _Tab.lastYearDetailed:
                return _DetailedChart(
                  data: _ratesData.lastYearRatesData.data,
                  classLevelRateAccessor: _classLevelRateAccessor,
                );
              case _Tab.historyChart:
                return _DetailedChart(
                  data: _ratesData.lastYearRatesData.data,
                  classLevelRateAccessor: _classLevelRateAccessor,
                );
              case _Tab.historyTable:
                return _DetailedChart(
                  data: _ratesData.lastYearRatesData.data,
                  classLevelRateAccessor: _classLevelRateAccessor,
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
  lastYearDetailed,
  historyChart,
  historyTable,
}

class _DetailedChart extends StatelessWidget {
  final List<ClassLevelRatesData> _data;
  final ClassLevelRateAccessor _classLevelRateAccessor;

  const _DetailedChart({
    Key key,
    @required List<ClassLevelRatesData> data,
    @required ClassLevelRateAccessor classLevelRateAccessor,
  })  : assert(data != null),
        assert(classLevelRateAccessor != null),
        _data = data,
        _classLevelRateAccessor = classLevelRateAccessor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 328 / 246,
      child: FutureBuilder(
        future: _series,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return charts.BarChart(
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
                lineStyle: chartAxisLineStyle,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final data = _data.map((it) {
        return BarChartData(
          it.classLevel,
          _classLevelRateAccessor.call(it),
          AppColors.kBlue,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          id: 'data',
          data: data,
        ),
      ];
    });
  }
}
