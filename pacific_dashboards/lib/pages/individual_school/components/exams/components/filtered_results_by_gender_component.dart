import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/bar_chart_data.dart';
import 'package:pacific_dashboards/shared_ui/chart_legend_item.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FilteredResultsByGenderComponent extends StatelessWidget {
  final Stream<bool> _loadingStream;
  final Stream<ExamReportsFilteredData> _dataStream;

  const FilteredResultsByGenderComponent({
    Key key,
    @required Stream<bool> loadingStream,
    @required Stream<ExamReportsFilteredData> dataStream,
  })  : assert(loadingStream != null),
        assert(dataStream != null),
        _loadingStream = loadingStream,
        _dataStream = dataStream,
        super(key: key);

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
            return Container(
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
                  ...List.generate(4, (index) {
                    return _GenderResults(
                      maxMale: data.byGender.maxMaleCandidates,
                      maxFemale: data.byGender.maxFemaleCandidates,
                      data: _getGenderDataByIndex(index, data.byGender),
                      title: _getGenderDataTitleByIndex(context, index),
                      needToShowMeasureAxis: index == 3,
                    );
                  }),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ChartLegendItem(
                        color: AppColors.kRed,
                        value: 'labelFemale'.localized(context),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ChartLegendItem(
                        color: AppColors.kBlue,
                        value: 'labelMale'.localized(context),
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

  ExamReportsGenderData _getGenderDataByIndex(
    int index,
    ExamReportsGenderResults results,
  ) {
    switch (index) {
      case 0:
        return results.competentData;
      case 1:
        return results.minimallyData;
      case 2:
        return results.approachingData;
      case 3:
        return results.wellBelowData;
    }
    throw FallThroughError();
  }

  String _getGenderDataTitleByIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        return 'individualSchoolExamsByBenchmarkCompetentLevel'
            .localized(context);
      case 1:
        return 'individualSchoolExamsByBenchmarkMinimallyLevel'
            .localized(context);
      case 2:
        return 'individualSchoolExamsByBenchmarkApproachingLevel'
            .localized(context);
      case 3:
        return 'individualSchoolExamsByBenchmarkWellBelowLevel'
            .localized(context);
    }
    throw FallThroughError();
  }
}

class _GenderResults extends StatelessWidget {
  final int _maxFemale;
  final int _maxMale;
  final ExamReportsGenderData _data;
  final String _title;
  final bool _needToShowMeasureAxis;

  const _GenderResults({
    Key key,
    @required int maxFemale,
    @required int maxMale,
    @required ExamReportsGenderData data,
    @required String title,
    @required bool needToShowMeasureAxis,
  })  : assert(maxFemale != null),
        assert(maxMale != null),
        assert(data != null),
        assert(title != null),
        assert(needToShowMeasureAxis != null),
        _maxFemale = maxFemale,
        _maxMale = maxMale,
        _data = data,
        _title = title,
        _needToShowMeasureAxis = needToShowMeasureAxis,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          _title,
          style: Theme.of(context).textTheme.individualDashboardsExamSubtitle,
        ),
        const SizedBox(
          height: 8,
        ),
        _GenderChart(
          maxFemale: _maxFemale,
          maxMale: _maxMale,
          data: _data,
          needToShowMeasureAxis: _needToShowMeasureAxis,
        ),
        SizedBox(
          height: _needToShowMeasureAxis ? 32 : 16,
        ),
      ],
    );
  }
}

class _GenderChart extends StatelessWidget {
  final int _maxFemale;
  final int _maxMale;
  final ExamReportsGenderData _data;
  final bool _needToShowMeasureAxis;

  const _GenderChart({
    Key key,
    @required int maxFemale,
    @required int maxMale,
    @required ExamReportsGenderData data,
    @required bool needToShowMeasureAxis,
  })  : assert(maxFemale != null),
        assert(maxMale != null),
        assert(data != null),
        assert(needToShowMeasureAxis != null),
        _maxFemale = maxFemale,
        _maxMale = maxMale,
        _data = data,
        _needToShowMeasureAxis = needToShowMeasureAxis,
        super(key: key);

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
                (number) => '${_needToShowMeasureAxis ? number.round().abs() : ''}',
              ),
              viewport: charts.NumericExtents(-_maxFemale, _maxMale),
            ),
            domainAxis: const charts.OrdinalAxisSpec(
              showAxisLine: false,
              renderSpec: const charts.NoneRenderSpec(),
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

  Future<List<charts.Series<BarChartData, String>>> get _seriesList {
    return Future.microtask(() {
      final data = [
        BarChartData(
          'domain',
          -_data.female,
          AppColors.kRed,
        ),
        BarChartData(
          'domain',
          _data.male,
          AppColors.kBlue,
        ),
      ];

      return [
        charts.Series(
          id: 'gender_data',
          domainFn: (BarChartData chartData, _) => chartData.domain,
          measureFn: (BarChartData chartData, _) => chartData.measure,
          colorFn: (BarChartData chartData, _) => chartData.color.chartsColor,
          data: data,
        ),
      ];
    });
  }
}
