import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/wash/question.dart';

class WashTotalsViewData {
  final Question selectedQuestion;
  final List<WashTotalsViewDataByDistrict> data;
  final int year;

  const WashTotalsViewData({
    @required this.selectedQuestion,
    @required this.data,
    @required this.year,
  });
}

class WashTotalsViewDataByDistrict {
  final String district;
  final List<WashTotalsViewDataByAnswer> answerDataList;

  const WashTotalsViewDataByDistrict({
    @required this.district,
    @required this.answerDataList,
  });
}

class WashTotalsViewDataByAnswer {
  final String answer;
  final int accumulated;
  final int evaluated;

  const WashTotalsViewDataByAnswer({
    @required this.answer,
    @required this.accumulated,
    @required this.evaluated,
  });
}