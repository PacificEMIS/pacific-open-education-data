import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/wash/question.dart';

class WashTotalsViewData {
  const WashTotalsViewData({
    @required this.selectedQuestion,
    @required this.data,
    @required this.year,
  });

  final Question selectedQuestion;
  final List<WashTotalsViewDataByDistrict> data;
  final int year;
}

class WashTotalsViewDataByDistrict {
  const WashTotalsViewDataByDistrict({
    @required this.district,
    @required this.answerDataList,
  });

  final String district;
  final List<WashTotalsViewDataByAnswer> answerDataList;
}

class WashTotalsViewDataByAnswer {
  const WashTotalsViewDataByAnswer({
    @required this.answer,
    @required this.accumulated,
    @required this.evaluated,
  });

  final String answer;
  final int accumulated;
  final int evaluated;
}
