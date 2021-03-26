import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
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
            style: textTheme.headline4,
          ),
        ),
        MiniTabLayout(
          tabs: _Tab.values,
          tabNameBuilder: (tab) {
            switch (tab) {
              case _Tab.lastYearDetailed:
                return '${_ratesData.lastYearRatesData.year}'
                    '${'individualSchoolDashboardRatesDetailed'.localized(context)}';
              case _Tab.historyChart:
                return 'individualSchoolDashboardRatesHistoryChart'
                    .localized(context);
              case _Tab.historyTable:
                return 'individualSchoolDashboardRatesHistoryTable'
                    .localized(context);
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
                return _HistoryTable(
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
  historyTable,
  historyChart,
  lastYearDetailed,
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

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      final data = _data.map((it) {
        return ChartData(
          it.classLevel,
          _classLevelRateAccessor.call(it),
          AppColors.kBlue,
        );
      }).toList();

      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'data',
          data: data,
        ),
      ];
    });
  }
}

// ignore: must_be_immutable
class _Chart extends StatelessWidget {
  final List<YearByClassLevelRateData> _data;
  final YearRateAccessor _yearRateAccessor;
  Map<String, Color> _colorScheme;

  _Chart({
    Key key,
    @required List<YearByClassLevelRateData> data,
    @required YearRateAccessor yearRateAccessor,
  })  : assert(data != null),
        assert(yearRateAccessor != null),
        _data = data,
        _yearRateAccessor = yearRateAccessor,
        super(key: key) {
    _colorScheme = _generateColorScheme();
  }

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
          colorFn: (item) => _colorScheme[item],
        ),
      ],
    );
  }

  Map<String, Color> _generateColorScheme() {
    final colorScheme = Map<String, Color>();
    var colorIndex = 0;
    _data.forEach((it) {
      final domain = it.classLevel;
      if (!colorScheme.containsKey(domain)) {
        if (colorIndex >= AppColors.kDynamicPalette.length) {
          colorScheme[domain] = HexColor.fromStringHash(domain);
        } else {
          colorScheme[domain] = AppColors.kDynamicPalette[colorIndex];
          colorIndex++;
        }
      }
    });
    return colorScheme;
  }

  Future<List<charts.Series<ChartData, String>>> get _series {
    return Future.microtask(() {
      int maxYear;
      int minYear;
      final gradesData = _data.map((data) {
        return data.data.map((item) {
          if (maxYear == null || maxYear < item.year) {
            maxYear = item.year;
          }
          if (minYear == null || minYear > item.year) {
            minYear = item.year;
          }

          return ChartData(
            '${item.year}',
            _yearRateAccessor.call(item),
            _colorScheme[data.classLevel],
          );
        }).toList();
      }).toList();

      return [
        charts.Series(
          domainFn: (ChartData chartData, _) => chartData.domain,
          measureFn: (ChartData chartData, _) => chartData.measure,
          colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          areaColorFn: (ChartData chartData, _) => chartData.color.chartsColor,
          id: 'data[-1]',
          data: List.generate(
            maxYear - minYear,
            (index) => ChartData('${minYear + index}', null, null),
          ),
        ),
        ...gradesData.mapIndexed((index, data) {
          return charts.Series(
            domainFn: (ChartData chartData, _) => chartData.domain,
            measureFn: (ChartData chartData, _) => chartData.measure,
            colorFn: (ChartData chartData, _) => chartData.color.chartsColor,
            areaColorFn: (ChartData chartData, _) => chartData.color.chartsColor,
            id: 'data[$index]',
            data: data,
          );
        }).toList(),
      ];
    });
  }
}

// ignore: must_be_immutable
class _LongLegend extends StatelessWidget {
  static const _kMaxItemsInRow = 5;

  final Color Function(String) _colorFn;
  List<List<String>> _items;

  _LongLegend({
    Key key,
    @required List<String> items,
    @required Color Function(String) colorFn,
  })  : assert(items != null),
        assert(colorFn != null),
        _colorFn = colorFn,
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
                if (index > 0) SizedBox(width: 16),
                ChartLegendItem(
                  color: _colorFn.call(item),
                  value: item,
                ),
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

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;
const double _kCellWidth = 64;
const double _kCellHeight = 40;

class _HistoryTable extends StatelessWidget {
  final List<YearByClassLevelRateData> _data;
  final YearRateAccessor _yearRateAccessor;

  const _HistoryTable({
    Key key,
    @required List<YearByClassLevelRateData> data,
    @required YearRateAccessor yearRateAccessor,
  })  : assert(data != null),
        assert(yearRateAccessor != null),
        _data = data,
        _yearRateAccessor = yearRateAccessor,
        super(key: key);

  List<int> _generateDomainYears() {
    final Set<int> years = {};
    _data.forEach((dataByClassLevel) {
      years.addAll(dataByClassLevel.data.map((it) => it.year));
    });
    return years.toList().chainSort((lv, rv) => lv.compareTo(rv));
  }

  List<String> get _classLevels {
    return _data.map((it) => it.classLevel).toList();
  }

  @override
  Widget build(BuildContext context) {
    final years = _generateDomainYears();
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        border: Border.all(
          width: _kBorderWidth,
          color: _kBorderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _Cell(
                value: 'individualSchoolDashboardRatesHistoryTableDomain'
                    .localized(context),
                cellType: _CellType.header,
              ),
              Container(
                width: _kCellWidth,
                height: _kBorderWidth,
                color: _kBorderColor,
              ),
              for (var classLevel in _classLevels)
                _Cell(
                  value: classLevel,
                  cellType: _CellType.domain,
                ),
            ],
          ),
          Container(
            height: _kCellHeight * (_classLevels.length + 1),
            width: _kBorderWidth,
            color: _kBorderColor,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: years
                        .map((year) => _Cell(
                              value: '$year',
                              cellType: _CellType.header,
                            ))
                        .toList(),
                  ),
                  Container(
                    width: _kCellWidth * years.length,
                    height: _kBorderWidth,
                    color: _kBorderColor,
                  ),
                  for (var measure in _data)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: years.map(
                        (year) {
                          final dataOnYear = measure.data.firstWhere(
                            (it) => it.year == year,
                            orElse: () => null,
                          );
                          String value = '-';
                          if (dataOnYear != null) {
                            value = _yearRateAccessor
                                    .call(dataOnYear)
                                    ?.toStringAsFixed(2) ??
                                '-';
                          }
                          return _Cell(
                            value: value,
                            cellType: _CellType.measure,
                          );
                        },
                      ).toList(),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String _value;
  final _CellType _cellType;

  const _Cell({
    Key key,
    @required String value,
    @required _CellType cellType,
  })  : _value = value,
        _cellType = cellType,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kCellWidth,
      height: _kCellHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            _value,
            maxLines: 1,
            style: _getTextStyle(context),
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (_cellType) {
      case _CellType.header:
        return Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: AppColors.kTextMinor);
      case _CellType.domain:
        return Theme.of(context).textTheme.overline;
      case _CellType.measure:
        return Theme.of(context)
            .textTheme
            .overline
            .copyWith(fontWeight: FontWeight.w600);
    }
    throw FallThroughError();
  }
}

enum _CellType { header, domain, measure }
