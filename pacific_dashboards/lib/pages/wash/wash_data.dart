import 'package:flutter/foundation.dart';

class WashData {
  final String year;
  final bool showAllData;
  final List<ListData> washModelList;
  final List<ListData> toiletsModelList;
  final List<ListData> waterModelList;

  const WashData({
      @required this.year,
      @required this.showAllData,
      @required this.washModelList,
      @required this.toiletsModelList,
      @required this.waterModelList})
      : assert(year != null),
        assert(showAllData != null),
        assert(washModelList != null),
        assert(toiletsModelList != null),
        assert(waterModelList != null);
}

class ListData {
  final String title;
  final List<int> values;
  int total;

  ListData({@required this.title, @required this.values}) {
    total = values.reduce((a, b) => a + b);
  }
}
