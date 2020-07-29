import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/utils/collections.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/utils/hex_color.dart';

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
                return _Chart(
                  data: _ratesData.historicalData,
                  yearRateAccessor: _yearRateAccessor,
                );
              case _Tab.historyTable:
                return _Chart(
                  data: _ratesData.historicalData,
                  yearRateAccessor: _yearRateAccessor,
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

class _Chart extends StatelessWidget {
  final List<YearByClassLevelRateData> _data;
  final YearRateAccessor _yearRateAccessor;

  const _Chart({
    Key key,
    @required List<YearByClassLevelRateData> data,
    @required YearRateAccessor yearRateAccessor,
  })  : assert(data != null),
        assert(yearRateAccessor != null),
        _data = data,
        _yearRateAccessor = yearRateAccessor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 328 / 212,
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
        _LongLegend(
          items: _data.map((it) => it.classLevel).toList(),
        ),
      ],
    );
  }

  Future<List<charts.Series<BarChartData, String>>> get _series {
    return Future.microtask(() {
      final gradesData = _data.map((data) {
        return data.data.map((item) {
          return BarChartData(
            '${item.year}',
            _yearRateAccessor.call(item),
            HexColor.fromStringHash(data.classLevel),
          );
        }).toList();
      }).toList();

      return gradesData.mapIndexed((index, data) {
        return charts.Series(
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (BarChartData chartData, _) =>
              chartData.color.chartsColor,
          id: 'data[$index]',
          data: data,
        );
      }).toList();
    });
  }
}

// ignore: must_be_immutable
class _LongLegend extends StatelessWidget {
  static const _kMaxItemsInRow = 6;
  List<List<String>> _items;

  _LongLegend({
    Key key,
    @required List<String> items,
  })  : assert(items != null),
        super(key: key) {
    _items = _splitItems(items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _items.map((rowItems) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowItems.mapIndexed((index, item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (index > 0)
                  SizedBox(
                    width: 16,
                  ),
                ChartLegendItem(
                  color: HexColor.fromStringHash(item),
                  value: item,
                )
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  List<List<String>> _splitItems(List<String> items) {
    final List<List<String>> result = [];
    List<String> buffer = [];
    for (var it in items) {
      if (buffer.length >= _kMaxItemsInRow) {
        result.add(buffer);
        buffer = [];
      }
      buffer.add(it);
    }
    if (buffer.isNotEmpty) {
      result.add(buffer);
    }
    return result;
  }
}
