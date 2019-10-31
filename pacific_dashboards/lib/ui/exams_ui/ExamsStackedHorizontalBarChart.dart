import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/config/Constants.dart';
import 'package:pacific_dashboards/models/ExamModel.dart';

class ExamsStackedHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ExamsStackedHorizontalBarChart(this.seriesList, {this.animate});

  factory ExamsStackedHorizontalBarChart.fromModel(ExamModel examModel) {
    return new ExamsStackedHorizontalBarChart(
      _createData(examModel),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        constraints: BoxConstraints.expand(
          height: 140.0,
        ),
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        alignment: Alignment.center,
        child: Stack(children: [
          IgnorePointer(
            child: charts.BarChart(
              seriesList,
              animate: animate,
              barGroupingType: charts.BarGroupingType.stacked,
              vertical: false,
              layoutConfig: new charts.LayoutConfig(
                  leftMarginSpec: new charts.MarginSpec.fixedPixel(20),
                  topMarginSpec: new charts.MarginSpec.fixedPixel(2),
                  rightMarginSpec: new charts.MarginSpec.fixedPixel(20),
                  bottomMarginSpec: new charts.MarginSpec.fixedPixel(4)),
              primaryMeasureAxis: new charts.NumericAxisSpec(
                  showAxisLine: false,
                  renderSpec: new charts.NoneRenderSpec(),
                  tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                      dataIsInWholeNumbers: true, desiredTickCount: 11),
                  viewport: new charts.NumericExtents(-100.0, 100.0)),
              domainAxis: new charts.OrdinalAxisSpec(
                  showAxisLine: false,
                  renderSpec:
                      new charts.SmallTickRendererSpec(tickLengthPx: 0)),
              defaultRenderer: new charts.BarRendererConfig(
                  stackHorizontalSeparator: 0,
                  groupingType: charts.BarGroupingType.stacked,
                  strokeWidthPx: 1),
            ),
          ),
          Center(
              widthFactor: 320,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _generateTitles()
                  )),
        ]));
  }

  List<Widget> _generateTitles() {
    List<Widget> titlesList = new List<Widget>();
    titlesList.add(Container(width: 30));
    for (int i = -80; i < 100; i += 20) {
      var text = i.toString();
      if (text != "0") {
        titlesList.add(
          Container(
            width: 25,
            child: new Text(
              text != "0" ? text : "",
              style: new TextStyle(
                  fontSize: 12.0, color: AppColors.kExamsTableTextGray),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        );
      } else {
        titlesList.add(Container(
            width: 25,
            child: Center(
                child: Container(
              color: AppColors.kExamsTableTextGray,
              width: 1,
              height: 120,
            ))));
      }
    }
    titlesList.add(Container(width: 30));
    return titlesList;
  }

  static List<charts.Series<ExamResultPercent, String>> _createData(
      ExamModel examModel) {
    
    bool isIncorrectFData = examModel.candidatesF == 0;
    bool isIncorrectMData = examModel.candidatesM == 0;
    
    final percentFail1 = [
      new ExamResultPercent(
          'F', isIncorrectFData ? 0 : (-examModel.resultsF[0] * 100 / examModel.candidatesF).round()),
      new ExamResultPercent(
          'M', isIncorrectMData ? 0 : (-examModel.resultsM[0] * 100 / examModel.candidatesM).round()),
    ];

    final percentFail2 = [
      new ExamResultPercent(
          'F', isIncorrectFData ? 0 : (-examModel.resultsF[1] * 100 / examModel.candidatesF).round()),
      new ExamResultPercent(
          'M', isIncorrectMData ? 0 : (-examModel.resultsM[1] * 100 / examModel.candidatesM).round()),
    ];

    final percentCompetent1 = [
      new ExamResultPercent(
          'F', isIncorrectFData ? 0 : (examModel.resultsF[2] * 100 / examModel.candidatesF).round()),
      new ExamResultPercent(
          'M', isIncorrectMData ? 0 : (examModel.resultsM[2] * 100 / examModel.candidatesM).round()),
    ];

    final percentCompetent2 = [
      new ExamResultPercent(
          'F', isIncorrectFData ? 0 : (examModel.resultsF[3] * 100 / examModel.candidatesF).round()),
      new ExamResultPercent(
          'M', isIncorrectMData ? 0 : (examModel.resultsM[3] * 100 / examModel.candidatesM).round()),
    ];

    final percentFiller1 = [
      new ExamResultPercent(
          'F', -100 - percentFail1[0].percent - percentFail2[0].percent),
      new ExamResultPercent(
          'M', -100 - percentFail1[1].percent - percentFail2[1].percent),
    ];

    final percentFiller2 = [
      new ExamResultPercent('F',
          100 - percentCompetent1[0].percent - percentCompetent2[0].percent),
      new ExamResultPercent('M',
          100 - percentCompetent1[1].percent - percentCompetent2[1].percent),
    ];

    return [
      new charts.Series<ExamResultPercent, String>(
        id: 'Result2',
        colorFn: (_, __) => charts.Color(r: 255, g: 186, b: 10),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFail2,
      ),
      new charts.Series<ExamResultPercent, String>(
        id: 'Result1',
        colorFn: (_, __) => charts.Color(r: 248, g: 84, b: 84),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFail1,
      ),
      new charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller1',
        colorFn: (_, __) => charts.Color(r: 245, g: 246, b: 248),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentFiller1,
      ),
      new charts.Series<ExamResultPercent, String>(
        id: 'Result3',
        colorFn: (_, __) => charts.Color(r: 148, g: 220, b: 57),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentCompetent1,
      ),
      new charts.Series<ExamResultPercent, String>(
        id: 'Result4',
        colorFn: (_, __) => charts.Color(r: 13, g: 211, b: 92),
        domainFn: (ExamResultPercent sales, _) => sales.gender,
        measureFn: (ExamResultPercent sales, _) => sales.percent,
        data: percentCompetent2,
      ),
      new charts.Series<ExamResultPercent, String>(
        id: 'ResultFiller2',
        colorFn: (_, __) => charts.Color(r: 245, g: 246, b: 248),
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

  ExamResultPercent(this.gender, this.percent);
}
