import 'dart:math';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';

import '../../../models/exam/exam_separated.dart';

class ExamsStackedHorizontalBarGenderChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  ExamsStackedHorizontalBarGenderChart(this.seriesList);

  static Widget fromModel(List<ExamSeparated> exam, BuildContext context,
      int mode) {
    return FutureBuilder(
      future: Future.microtask(() => _createData(exam, context, mode)),
      builder: (context, AsyncSnapshot<List<charts.Series>> snapshot) {
        if (!snapshot.hasData) {
          return PlatformProgressIndicator();
        }
        return ExamsStackedHorizontalBarGenderChart(snapshot.data);
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
            child: Padding(
              padding: EdgeInsets.only(left: 150),
              child: charts.BarChart(
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
          ),
          SizedBox(height:10),
          Center(
            widthFactor: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(width: 181),
                ...List.generate(9, (index) => -80 + 20 * index).map((it) {
                  final text = it.abs().toString();
                  if (text != "0") {
                    return Container(
                      width: 16,
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
                      width: 16,
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
          ),
        ],
      ),
    );
  }

  static num _numberForMode(List<ExamSeparated> exams, int mode) {
    if (exams.isEmpty) return 0;
    return (exams.reduce((value, element) => value + element))
        .modeParameter(mode);
  }

  static List<charts.Series<ExamResultPercent, String>> _createData(
      List<ExamSeparated> exams, BuildContext context, int mode) {
    final examsMale = exams.where((element) => element.gender == 'M').toList();
    final examsFemale = exams.where((element) => element.gender == 'F')
        .toList();

    var maleTotal = max(1.0, _numberForMode(examsMale, mode));
    var femaleTotal = max(1.0, _numberForMode(examsFemale, mode));

    final percentFemale = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent: (_numberForMode(
            examsFemale.where((e) => e.achievementLevel == 4).toList(),
            mode) * -100 / femaleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent: (_numberForMode(
            examsFemale.where((e) => e.achievementLevel == 3).toList(),
            mode) * -100 / femaleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent: (_numberForMode(
            examsFemale.where((e) => e.achievementLevel == 2).toList(),
            mode) * -100 / femaleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent: (_numberForMode(
            examsFemale.where((e) => e.achievementLevel == 1).toList(),
            mode) * -100 / femaleTotal).round(),
      ),
    ];

    final percentMale = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent: (_numberForMode(
            examsMale.where((e) => e.achievementLevel == 4).toList(),
            mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent: (_numberForMode(
            examsMale.where((e) => e.achievementLevel == 3).toList(),
            mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent: (_numberForMode(
            examsMale.where((e) => e.achievementLevel == 2).toList(),
            mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent: (_numberForMode(
            examsMale.where((e) => e.achievementLevel == 1).toList(),
            mode) * 100 / maleTotal).round(),
      ),
    ];

    final percentFiller1 = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent: -100 - percentFemale[0].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent: -100 - percentFemale[1].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent: -100 - percentFemale[2].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent: -100 - percentFemale[3].percent,
      ),
    ];

    final percentFiller2 = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent: 100 - percentMale[0].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent: 100 - percentMale[1].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent: 100 - percentMale[2].percent,
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent: 100 - percentMale[3].percent,
      ),
    ];

    return [
      charts.Series<ExamResultPercent, String>(
        id: 'Female',
        colorFn: (_, __) => const charts.Color(r: 248, g: 84, b: 84),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFemale,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Filler1',
        colorFn: (_, __) => const charts.Color(r: 245, g: 246, b: 248),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFiller1,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Male',
        colorFn: (_, __) => const charts.Color(r: 24, g: 115, b: 232),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentMale,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Filler2',
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
