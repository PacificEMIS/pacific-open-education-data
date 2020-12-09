import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

class ExamsStackedHorizontalBarChart extends StatelessWidget {
  const ExamsStackedHorizontalBarChart(this.seriesList, {Key key})
      : super(key: key);

  final List<charts.Series> seriesList;

  static Widget fromModel(Exam exam) {
    return FutureBuilder(
      future: Future.microtask(() => _createData(exam)),
      builder: (context, snapshot) {
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
              primaryMeasureAxis: const charts.NumericAxisSpec(
                showAxisLine: false,
                renderSpec: charts.NoneRenderSpec(),
                tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 11,
                ),
                viewport: charts.NumericExtents(-100.0, 100.0),
              ),
              domainAxis: const charts.OrdinalAxisSpec(
                showAxisLine: false,
                renderSpec: charts.SmallTickRendererSpec(
                  tickLengthPx: 0,
                  labelStyle: largeChartsDomain,
                ),
              ),
              defaultRenderer: charts.BarRendererConfig(
                stackHorizontalSeparator: 0,
                groupingType: charts.BarGroupingType.stacked,
                strokeWidthPx: 1,
              ),
            ),
          ),
          Center(
            widthFactor: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(width: 30),
                ...List.generate(9, (index) => -80 + 20 * index).map((it) {
                  final text = it.abs().toString();
                  if (text != '0') {
                    return SizedBox(
                      width: 25,
                      child: Text(
                        text != '0' ? text : '',
                        style: Theme.of(context).textTheme.overline.copyWith(
                              color: AppColors.kTextMinor.withOpacity(0.5),
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    );
                  } else {
                    return SizedBox(
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
          ),
        ],
      ),
    );
  }

  static List<charts.Series<ExamResultPercent, String>> _createData(Exam exam) {
    final isIncorrectFData = exam.candidatesF == 0;
    final isIncorrectMData = exam.candidatesM == 0;

    final percentFail1 = [
      ExamResultPercent(
        gender: 'F',
        percent: isIncorrectFData
            ? 0
            : (-exam.wellBelowCompetentF * 100 / exam.candidatesF).round(),
      ),
      ExamResultPercent(
        gender: 'M',
        percent: isIncorrectMData
            ? 0
            : (-exam.wellBelowCompetentM * 100 / exam.candidatesM).round(),
      ),
    ];

    final percentFail2 = [
      ExamResultPercent(
        gender: 'F',
        percent: isIncorrectFData
            ? 0
            : (-exam.approachingCompetenceF * 100 / exam.candidatesF).round(),
      ),
      ExamResultPercent(
        gender: 'M',
        percent: isIncorrectMData
            ? 0
            : (-exam.approachingCompetenceM * 100 / exam.candidatesM).round(),
      ),
    ];

    final percentCompetent1 = [
      ExamResultPercent(
        gender: 'F',
        percent: isIncorrectFData
            ? 0
            : (exam.minimallyCompetentF * 100 / exam.candidatesF).round(),
      ),
      ExamResultPercent(
        gender: 'M',
        percent: isIncorrectMData
            ? 0
            : (exam.minimallyCompetentM * 100 / exam.candidatesM).round(),
      ),
    ];

    final percentCompetent2 = [
      ExamResultPercent(
        gender: 'F',
        percent: isIncorrectFData
            ? 0
            : (exam.competentF * 100 / exam.candidatesF).round(),
      ),
      ExamResultPercent(
        gender: 'M',
        percent: isIncorrectMData
            ? 0
            : (exam.competentM * 100 / exam.candidatesM).round(),
      ),
    ];

    final percentFiller1 = [
      ExamResultPercent(
        gender: 'F',
        percent: -100 - percentFail1[0].percent - percentFail2[0].percent,
      ),
      ExamResultPercent(
        gender: 'M',
        percent: -100 - percentFail1[1].percent - percentFail2[1].percent,
      ),
    ];

    final percentFiller2 = [
      ExamResultPercent(
        gender: 'F',
        percent:
            100 - percentCompetent1[0].percent - percentCompetent2[0].percent,
      ),
      ExamResultPercent(
        gender: 'M',
        percent:
            100 - percentCompetent1[1].percent - percentCompetent2[1].percent,
      ),
    ];

    return [
      charts.Series<ExamResultPercent, String>(
        id: 'Result2',
        colorFn: (_, __) => const charts.Color(r: 255, g: 186, b: 10),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentFail2,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result1',
        colorFn: (_, __) => const charts.Color(r: 248, g: 84, b: 84),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentFail1,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller1',
        colorFn: (_, __) => const charts.Color(r: 245, g: 246, b: 248),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentFiller1,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result3',
        colorFn: (_, __) => const charts.Color(r: 148, g: 220, b: 57),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentCompetent1,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'Result4',
        colorFn: (_, __) => const charts.Color(r: 13, g: 211, b: 92),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentCompetent2,
      ),
      charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller2',
        colorFn: (_, __) => const charts.Color(r: 245, g: 246, b: 248),
        domainFn: (data, _) => data.gender,
        measureFn: (data, _) => data.percent,
        data: percentFiller2,
      ),
    ];
  }
}

class ExamResultPercent {
  const ExamResultPercent({this.gender, this.percent});

  final String gender;
  final int percent;
}
