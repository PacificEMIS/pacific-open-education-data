import 'package:flutter/foundation.dart';

class WashData {
  final List<ListData> washModelList;
  final List<ListData> toiletsModelList;
  final List<ListData> waterModelList;

  WashData(
      {@required this.washModelList,
      @required this.toiletsModelList,
      @required this.waterModelList});
}

class ListData {
  final String title;
  final List<int> values;
  int total;

  ListData({@required this.title, @required this.values}) {
    total = values.reduce((a, b) => a + b);
  }
}
