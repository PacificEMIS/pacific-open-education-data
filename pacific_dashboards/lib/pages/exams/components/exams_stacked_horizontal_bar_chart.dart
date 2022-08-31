import 'dart:math';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

import '../../../models/exam/exam_separated.dart';
import '../../../shared_ui/mini_tab_layout.dart';

class ExamsStackedHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  ExamsStackedHorizontalBarChart(this.seriesList);

  static Widget fromModel(List<ExamSeparated> exams, int mode) {
    return FutureBuilder(
      future: Future.microtask(() => _createData(exams, mode)),
      builder: (context, AsyncSnapshot<List<charts.Series>> snapshot) {
        if (!snapshot.hasData) {
          return PlatformProgressIndicator();
        }
        return ExamsStackedHorizontalBarChart(snapshot.data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 140.0),
      padding: const EdgeInsets.all(0.0),
      alignment: Alignment.center,
      child: Stack(
        children: [
          IgnorePointer(
            child:  charts.BarChart(
              seriesList,
              animate: false,
              barGroupingType: charts.BarGroupingType.stacked,
              vertical: false,
              layoutConfig: charts.LayoutConfig(
                leftMarginSpec: charts.MarginSpec.fixedPixel(20),
                topMarginSpec: charts.MarginSpec.fixedPixel(2),
                rightMarginSpec: charts.MarginSpec.fixedPixel(20),
                bottomMarginSpec: charts.MarginSpec.fixedPixel(4),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                showAxisLine: false,
                renderSpec: const charts.NoneRenderSpec(),
                tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 11,
                ),
                viewport: const charts.NumericExtents(-100.0, 100.0),
              ),
              domainAxis: const charts.OrdinalAxisSpec(
                showAxisLine: false,
                renderSpec: const charts.SmallTickRendererSpec(
                  tickLengthPx: 0,
                  labelStyle: largeChartsDomain,
                ),
              ),
              defaultRenderer: charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.stacked,
                strokeWidthPx: 1,
              ),
            ),
          ),
          buildExamMeasureAxis(context),
        ],
      ),
    );
  }

  Center buildExamMeasureAxis(BuildContext context) {
    return Center(
          widthFactor: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(width: 30),
              ..._generateExamsMeasureAxis(start: -80, step: 20, num: 9).map((it) {
                final text = it.abs().toString();
                if (text != "0") {
                  return Container(
                    width: 25,
                    child: Text(
                      text != "0" ? text : "",
                      style: Theme
                          .of(context)
                          .textTheme
                          .overline
                          .copyWith(
                        color: AppColors.kTextMinor.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  );
                } else {
                  return Container(
                    width: 25,
                    child: Center(
                      child: Container(
                        color: AppColors.kTextMinor,
                        width: 1,
                        height: 120,
                      ),
                    ),
                  );
                }
              }).toList(),
              Container(width: 30),
            ],
          ),
        );
  }

  /**
   * Generate mesure axis for Exams dashboard section from -80 to 80(step 20)
   */
  List<int> _generateExamsMeasureAxis({@required int start, @required int num, @required int step}) => List.generate
  (num,
          (index) => start +
      step * index);

  static num _numberForMode(List<ExamSeparated> exams, int mode) {
    if (exams.isEmpty) return 0;
    return (exams.reduce((value, element) => value + element))
        .modeParameter(mode);
  }

  static List<charts.Series<ExamResultPercent, String>> _createData(
      List<ExamSeparated> exams, int mode) {
    final examsMale = exams.where((element) => element.gender == 'M').toList();
    final examsFemale = exams.where((element) => element.gender == 'F')
        .toList();
    var maleTotal = max(1.0, _numberForMode(examsMale, mode));
    var femaleTotal = max(1.0, _numberForMode(examsFemale, mode));
    var allTotal = max(1.0, _numberForMode(exams, mode));

    final percentages = <List<ExamResultPercent>>[];
    for (int i = 1; i < 5; i++) {
      percentages.add([
        ExamResultPercent(
          gender: 'M',
          percent: (_numberForMode(
              examsMale.where((e) => e.achievementLevel == i).toList(),
              mode) *
              100 / maleTotal).round() * (i < 3 ? -1 : 1),
        ),
        ExamResultPercent(
          gender: 'All',
          percent: (_numberForMode(
              exams.where((e) => e.achievementLevel == i).toList(), mode) *
              100 / allTotal).round() * (i < 3 ? -1 : 1),
        ),
        ExamResultPercent(
          gender: 'F',
          percent: (_numberForMode(
              examsFemale.where((e) => e.achievementLevel == i).toList(),
              mode) * 100 / femaleTotal).round() * (i < 3 ? -1 : 1),
        ),
      ]);
    }

    final percentFiller1 = [
      ExamResultPercent(
        gender: 'M',
        percent: -100 - percentages[0][0].percent - percentages[1][0].percent,
      ),
      ExamResultPercent(
        gender: 'All',
        percent: -100 - percentages[0][1].percent - percentages[1][1].percent,
      ),
      ExamResultPercent(
        gender: 'F',
        percent: -100 - percentages[0][2].percent - percentages[1][2].percent,
      ),
    ];

    final percentFiller2 = [
      ExamResultPercent(
        gender: 'M',
        percent:
        100 - percentages[2][0].percent - percentages[3][0].percent,
      ),
      ExamResultPercent(
        gender: 'All',
        percent:
        100 - percentages[2][1].percent - percentages[3][1].percent,
      ),
      ExamResultPercent(
        gender: 'F',
        percent:
        100 - percentages[2][2].percent - percentages[3][2].percent,
      ),
    ];

    return [
      charts.Series<ExamResultPercent, String>(
        id: 'Result2',
        colorFn: (_, __) => charts.Color(r: 255, g: 186, b: 10),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentages[1],
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result1',
        colorFn: (_, __) => const charts.Color(r: 248, g: 84, b: 84),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentages[0],
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller1',
        colorFn: (_, __) => const charts.Color(r: 245, g: 246, b: 248),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFiller1,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result3',
        colorFn: (_, __) => const charts.Color(r: 148, g: 220, b: 57),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentages[2],
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result4',
        colorFn: (_, __) => const charts.Color(r: 13, g: 211, b: 92),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentages[3],
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller2',
        colorFn: (_, __) => const charts.Color(r: 245, g: 246, b: 248),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFiller2,
      ),
    ];
  }
}

class ExamResultPercent {
  final String gender;
  final int percent;

  ExamResultPercent({this.gender, this.percent});
}
