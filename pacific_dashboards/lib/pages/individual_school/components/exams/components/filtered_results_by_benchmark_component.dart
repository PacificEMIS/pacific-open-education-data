import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_legend_item.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FilteredResultsByBenchmarkComponent extends StatelessWidget {
  const FilteredResultsByBenchmarkComponent({
    Key key,
    @required Stream<bool> loadingStream,
    @required Stream<ExamReportsFilteredData> dataStream,
  })  : assert(loadingStream != null),
        assert(dataStream != null),
        _loadingStream = loadingStream,
        _dataStream = dataStream,
        super(key: key);

  final Stream<bool> _loadingStream;
  final Stream<ExamReportsFilteredData> _dataStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<bool>(
        stream: _loadingStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final isLoading = snapshot.data;
          if (isLoading) {
            return SizedBox(
              height: 100,
              child: Center(
                child: PlatformProgressIndicator(),
              ),
            );
          }
          return StreamBuilder<ExamReportsFilteredData>(
            stream: _dataStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              final data = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${data.year} ${data.examName}',
                    style: Theme.of(context)
                        .textTheme
                        .individualDashboardsExamSubtitle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  for (var benchmarkData in data.byBenchmark.dataByBenchmark)
                    _StandardResults(
                      maxNegative: data.byBenchmark.maxNegativeCandidates,
                      maxPositive: data.byBenchmark.maxPositiveCandidates,
                      data: benchmarkData,
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ChartLegendItem(
                        color: AppColors.kLevels[0],
                        value: 'individualSchoolExamsByBenchmarkWellBelowLevel'
                            .localized(context),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ChartLegendItem(
                        color: AppColors.kLevels[1],
                        value:
                            'individualSchoolExamsByBenchmarkApproachingLevel'
                                .localized(context),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ChartLegendItem(
                        color: AppColors.kLevels[2],
                        value: 'individualSchoolExamsByBenchmarkMinimallyLevel'
                            .localized(context),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ChartLegendItem(
                        color: AppColors.kLevels[3],
                        value: 'individualSchoolExamsByBenchmarkCompetentLevel'
                            .localized(context),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StandardResults extends StatelessWidget {
  const _StandardResults({
    Key key,
    @required int maxNegative,
    @required int maxPositive,
    @required ExamReportsBenchmarkData data,
  })  : assert(maxNegative != null),
        assert(maxPositive != null),
        assert(data != null),
        _maxNegative = maxNegative,
        _maxPositive = maxPositive,
        _data = data,
        super(key: key);

  final int _maxNegative;
  final int _maxPositive;
  final ExamReportsBenchmarkData _data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: '${_data.benchmarkCode} ',
            style: Theme.of(context).textTheme.individualDashboardsExamSubtitle,
            children: [
              TextSpan(
                text: _data.benchmarkDescription,
                style: Theme.of(context).textTheme.individualDashboardsExamBody,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        _StandardChart(
          maxNegative: _maxNegative,
          maxPositive: _maxPositive,
          data: _data,
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class _StandardChart extends StatelessWidget {
  const _StandardChart({
    Key key,
    @required int maxNegative,
    @required int maxPositive,
    @required ExamReportsBenchmarkData data,
  })  : assert(maxNegative != null),
        assert(maxPositive != null),
        assert(data != null),
        _maxNegative = maxNegative,
        _maxPositive = maxPositive,
        _data = data,
        super(key: key);

  final int _maxNegative;
  final int _maxPositive;
  final ExamReportsBenchmarkData _data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 32,
      child: FutureBuilder(
        future: _seriesList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return charts.BarChart(
            snapshot.data,
            animate: false,
            barGroupingType: charts.BarGroupingType.stacked,
            vertical: false,
            layoutConfig: charts.LayoutConfig(
              leftMarginSpec: charts.MarginSpec.fixedPixel(0),
              topMarginSpec: charts.MarginSpec.fixedPixel(0),
              rightMarginSpec: charts.MarginSpec.fixedPixel(0),
              bottomMarginSpec: charts.MarginSpec.fixedPixel(0),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              showAxisLine: false,
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: chartAxisTextStyle,
                lineStyle: chartAxisLineStyle,
              ),
              tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                dataIsInWholeNumbers: true,
                desiredTickCount: 11,
              ),
              tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                (number) => '${number.round().abs()}',
              ),
              viewport: charts.NumericExtents(-_maxNegative, _maxPositive),
            ),
            domainAxis: const charts.OrdinalAxisSpec(
              showAxisLine: false,
              renderSpec: charts.NoneRenderSpec(),
            ),
            defaultRenderer: charts.BarRendererConfig(
              stackHorizontalSeparator: 0,
              groupingType: charts.BarGroupingType.stacked,
              strokeWidthPx: 1,
            ),
          );
        },
      ),
    );
  }

  Future<List<charts.Series<ChartData, String>>> get _seriesList {
    return Future.microtask(() {
      final data = [
        ChartData(
          _data.benchmarkCode,
          -_data.approachingCount,
          AppColors.kLevels[1],
        ),
        ChartData(
          _data.benchmarkCode,
          -_data.minimallyCount,
          AppColors.kLevels[0],
        ),
        ChartData(
          _data.benchmarkCode,
          _data.minimallyCount,
          AppColors.kLevels[2],
        ),
        ChartData(
          _data.benchmarkCode,
          _data.competentCount,
          AppColors.kLevels[3],
        ),
      ];

      return [
        charts.Series(
          id: '${_data.benchmarkCode}_data',
          domainFn: (chartData, _) => chartData.domain,
          measureFn: (chartData, _) => chartData.measure,
          colorFn: (chartData, _) => chartData.color.chartsColor,
          data: data,
        ),
      ];
    });
  }
}
