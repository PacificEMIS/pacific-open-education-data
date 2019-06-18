import 'dart:convert';

import 'chart_model.dart';

class ItemModel {
  List<ChartModel> _charts;

  List<ChartModel> get charts => _charts;

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['charts'.length]);
    var list = parsedJson['charts'] as List;
    _charts = list.map((i) => ChartModel.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() {
    print(jsonEncode(_charts));

    return {
      'charts': jsonEncode(_charts),
    };
  }
}
