import 'dart:ffi';
import 'dart:math';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import '../../../models/exam/exam_separated.dart';
import '../../../shared_ui/charts/chart_legend_item.dart';
import '../../../shared_ui/tables/multi_table_widget.dart';
import '../../individual_school/components/dashboards/components/enroll/enroll_data.dart';

class ExamsStackedHorizontalBarGenderChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final List<ExamSeparated> exams;

  ExamsStackedHorizontalBarGenderChart(this.seriesList, this.exams);

  static Widget fromModel(List<ExamSeparated> exam, BuildContext context, int mode) {
    return FutureBuilder(
      future: Future.microtask(() => _createData(exam, context, mode)),
      builder: (context, AsyncSnapshot<List<charts.Series>> snapshot) {
        if (!snapshot.hasData) {
          return PlatformProgressIndicator();
        }
        return IgnorePointer(child: ExamsStackedHorizontalBarGenderChart(snapshot.data, exam));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DomainValueBuilder sAchievmentDomainValueBuilder = (index, data) {
      switch (index) {
        case 0:
          return CellData(value: data.domain);
        case 1:
          return CellData(value: data.measure.female.toString());
        case 2:
          return CellData(value: data.measure.male.toString());
        case 3:
          return CellData(value: data.measure.total.toString());
      }
      throw FallThroughError();
    };

    // var testMap = {seriesList[0].id: seriesList[0].data,
    //    seriesList[2].id: seriesList[2].data};
    //  // List<String> columns = seriesList[0].data.map((city) => city.gender.toString().replaceAll(RegExp(' '), '\n')).toList();
    //  // List<String> titles = ['Gender'];
    // titles.addAll(columns);
    // var testMap = seriesList[0].data.forEach((e) {
    //     final enroll = EnrollDataByGrade(grade: e.gender, )
    // });
    List<EnrollDataByGrade> dataByGrade = [];
    for (int i = 0; i < seriesList[0].data.length; i++) {
      final male = seriesList[2].data[i].percent;
      final female = -seriesList[0].data[i].percent;
      final total = male + female;

      dataByGrade.add(EnrollDataByGrade(grade: seriesList[0].data[i].gender, total: total, male: male, female: female));
    }
    return Column(children: [
      Stack(children: [
        Container(
            constraints: BoxConstraints.expand(height: 300.0),
            padding: const EdgeInsets.all(0.0),
            child: ListView.builder(
              itemCount: seriesList.first.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Padding(
                      padding: EdgeInsets.only(left: 5, top: 8.0 * index),
                      child: Text(
                        seriesList.first.data[index].gender,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black54),
                      )),
                );
              },
            )),
        Column(children: [
          Container(
              constraints: BoxConstraints.expand(height: 300.0),
              padding: const EdgeInsets.all(0.0),
              child: charts.BarChart(
                seriesList,
                animate: false,
                barGroupingType: charts.BarGroupingType.stacked,
                vertical: false,
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
                  renderSpec: const charts.NoneRenderSpec(),
                ),
                behaviors: [new charts.PanAndZoomBehavior()],
                defaultRenderer:
                    charts.BarRendererConfig(groupingType: charts.BarGroupingType.stacked, maxBarWidthPx: 30),
              )),
          SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ChartLegendItem(
                    color: AppColors.kRed,
                    value: 'labelFemale'.localized(context),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ChartLegendItem(
                    color: AppColors.kBlue,
                    value: 'labelMale'.localized(context),
                  ),
                ],
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints.expand(height: 250.0),
            padding: const EdgeInsets.only(top: 10.0),
            child: MultiTableWidget(
              data: Map.fromIterable(dataByGrade, key: (e) => e.grade, value: (e) => e),
              columnNames: [
                'Competent',
                'Total',
                'Male',
                'Female',
              ],
              columnFlex: [3, 3, 3, 3],
              domainValueBuilder: sAchievmentDomainValueBuilder,
            ),
          ),
        ]),
        Container(
          height: 302,
          child: buildExamMeasureAxis(context),
        ),
      ])
    ]);
  }

  Row buildExamMeasureAxis(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(width: 30),
        ..._generateExamsMeasureAxis(start: -80, step: 20, num: 9).map((it) {
          final text = it.abs().toString();
          if (text != "0") {
            return Container(
              width: 25,
              child: Text(
                text != "0" ? text : "",
                style: Theme.of(context).textTheme.overline.copyWith(
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
                  height: 225,
                ),
              ),
            );
          }
        }).toList(),
        Container(width: 30),
      ],
    );
  }

  /**
   * Generate mesure axis for Exams dashboard section from -80 to 80(step 20)
   */
  List<int> _generateExamsMeasureAxis({@required int start, @required int num, @required int step}) =>
      List.generate(num, (index) => start + step * index);

  static num _numberForMode(List<ExamSeparated> exams, int mode) {
    if (exams.isEmpty) return 0;
    return (exams.reduce((value, element) => value + element)).modeParameter(mode);
  }

  static List<charts.Series<ExamResultPercent, String>> _createData(
      List<ExamSeparated> exams, BuildContext context, int mode) {
    final examsMale = exams.where((element) => element.gender == 'M').toList();
    final examsFemale = exams.where((element) => element.gender == 'F').toList();

    var maleTotal = max(1.0, _numberForMode(examsMale, mode));
    var femaleTotal = max(1.0, _numberForMode(examsFemale, mode));

    final percentFemale = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent: (_numberForMode(examsFemale.where((e) => e.achievementLevel == 4).toList(), mode) * -100 / femaleTotal)
            .round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent: (_numberForMode(examsFemale.where((e) => e.achievementLevel == 3).toList(), mode) * -100 / femaleTotal)
            .round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent: (_numberForMode(examsFemale.where((e) => e.achievementLevel == 2).toList(), mode) * -100 / femaleTotal)
            .round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent: (_numberForMode(examsFemale.where((e) => e.achievementLevel == 1).toList(), mode) * -100 / femaleTotal)
            .round(),
      ),
    ];

    final percentMale = [
      ExamResultPercent(
        gender: 'achievementLevel4'.localized(context),
        percent:
            (_numberForMode(examsMale.where((e) => e.achievementLevel == 4).toList(), mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel3'.localized(context),
        percent:
            (_numberForMode(examsMale.where((e) => e.achievementLevel == 3).toList(), mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel2'.localized(context),
        percent:
            (_numberForMode(examsMale.where((e) => e.achievementLevel == 2).toList(), mode) * 100 / maleTotal).round(),
      ),
      ExamResultPercent(
        gender: 'achievementLevel1'.localized(context),
        percent:
            (_numberForMode(examsMale.where((e) => e.achievementLevel == 1).toList(), mode) * 100 / maleTotal).round(),
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
