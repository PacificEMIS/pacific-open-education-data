import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/wash/water.dart';

class WashData {
  final String year;
  final List<ListData> washModelList;
  final Map<String, List<WaterData>> toiletsModelList;
  final Map<String, List<WaterData>> waterModelList;

  const WashData(
      {@required this.year,
      @required this.washModelList,
      @required this.toiletsModelList,
      @required this.waterModelList})
      : assert(year != null),
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

class WaterData {
  final String title;
  final Map<String, int> values;

  const WaterData({@required this.title, @required this.values})
      : assert(title != null),
        assert(values != null);
}
