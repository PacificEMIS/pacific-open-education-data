import 'dart:ffi';

import 'package:arch/arch.dart';
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
import '../../../shared_ui/tables/chart_info_table_widget.dart';
import '../special_education_data.dart';

class SpecialEducationComponent extends StatefulWidget {
  final List<DataByGroup> data;
  final bool showTabs;
  const SpecialEducationComponent({
    Key key,
    @required this.data,
    this.showTabs = true,
  })  : assert(data != null),
        super(key: key);

  @override
  _SpecialEducationComponentState createState() => _SpecialEducationComponentState();
}

class _SpecialEducationComponentState extends State<SpecialEducationComponent> {
  Future<Map<String, Color>> get _colorScheme {
    return Future.microtask(() {
      final colorScheme = Map<String, Color>();
      final domains = widget.data.map((e) => e.title).toList();
      domains.forEachIndexed((index, item) {
        colorScheme[item] =
            index < AppColors.kDynamicPalette.length ? AppColors.kDynamicPalette[index] : HexColor.fromStringHash(item);
      });
      return colorScheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'labelNoData'.localized(context),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    }
    return FutureBuilder<Map<String, Color>>(
      future: _colorScheme,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final colorScheme = snapshot.data;
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              widget.showTabs
                  ? MiniTabLayout(
                      tabs: _Tab.values,
                      tabNameBuilder: (tab) {
                        switch (tab) {
                          case _Tab.schedule:
                            return 'specialEducationTabNameSchedule'.localized(context);
                          case _Tab.diagram:
                            return 'specialEducationTabNameDiagram'.localized(context);
                        }
                        throw FallThroughError();
                      },
                      builder: (ctx, tab) {
                        switch (tab) {
                          case _Tab.schedule:
                            return ChartWithTable(
                              key: ObjectKey(widget.data),
                              title: '',
                              data: widget.data
                                  .map((it) => ChartData(
                                        it.title.localized(context),
                                        it.total,
                                        colorScheme[it.title],
                                      ))
                                  .toList(),
                              chartType: ChartType.bar,
                              tableKeyName: 'specialEducationAuthorityDomain'.localized(context),
                              tableValueName: 'specialEducationEnrollDomain'.localized(context),
                            );
                          case _Tab.diagram:
                            return ChartWithTable(
                              key: ObjectKey(widget.data),
                              title: '',
                              data: widget.data
                                  .map((it) => ChartData(
                                        it.title.localized(context),
                                        it.total,
                                        colorScheme[it.title],
                                      ))
                                  .toList(),
                              chartType: ChartType.pie,
                              tableKeyName: 'specialEducationAuthorityDomain'.localized(context),
                              tableValueName: 'specialEducationEnrollDomain'.localized(context),
                            );
                        }
                        throw FallThroughError();
                      },
                    )
                  : Column(
                      children: [
                        _Chart(
                          data: widget.data,
                          colorScheme: colorScheme,
                        ),
                        ChartWithTable(
                          key: ObjectKey(widget.data),
                          title: '',
                          data: widget.data
                              .map((it) => ChartData(
                                    it.title.localized(context),
                                    it.total,
                                    colorScheme[it.title],
                                  ))
                              .toList(),
                          chartType: ChartType.none,
                            tableKeyName: 'specialEducationAuthorityDomain'.localized(context),
                          tableValueName: 'specialEducationEnrollDomain'.localized(context),
                        )
                      ],

                    )
            ]);
      },
    );
  }
}

enum _Tab {
  schedule,
  diagram,
}

class _Chart extends StatelessWidget {
  final List<DataByGroup> _data;
  final List<ChartData> _chartData;

  final Map<String, Color> _colorScheme;

  const _Chart({
    Key key,
    @required List<DataByGroup> data,
    @required List<ChartData> chartData,
    @required Map<String, Color> colorScheme,
  })  : assert(data != null),
        assert(colorScheme != null),
        _colorScheme = colorScheme,
        _data = data,
        _chartData = chartData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FutureBuilder(
          future: _createSeries(context, _colorScheme),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final uniqueDomainsLenght = _data.uniques((it) => it.title).length;
            return SizedBox(
              height: uniqueDomainsLenght * (uniqueDomainsLenght > 5 ? 40.5 : 80.5),
              child: charts.BarChart(
                snapshot.data,
                animate: false,
                barGroupingType: charts.BarGroupingType.stacked,
                vertical: false,
                defaultInteractions: false,
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
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ChartLegendItem(
              color: AppColors.kFemale,
              value: 'labelFemale'.localized(context),
            ),
            SizedBox(
              width: 16,
            ),
            ChartLegendItem(
              color: AppColors.kMale,
              value: 'labelMale'.localized(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<charts.Series<ChartData, String>>> _createSeries(
    BuildContext context,
    Map<String, Color> colorScheme,
  ) {
    return Future.microtask(() {
      final barChartData = _data.expand((it) {
        final title = it.title.localized(context).addNewLineIfLong();
        return [
          ChartData(
            title,
            it.firstValue,
            AppColors.kFemale,
          ),
          ChartData(
            title,
            it.secondValue,
            AppColors.kMale,
          ),
        ];
      }).toList();
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

extension _StringOverflowExt on String {
  String addNewLineIfLong() => length > 15 ? replaceFirst(RegExp(r'\s'), '\n', 15) : this;
}
