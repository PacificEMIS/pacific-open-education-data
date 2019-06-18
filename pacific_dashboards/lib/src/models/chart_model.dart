import 'dart:convert';

import 'series_model.dart';

class ChartModel {
  String _chartName;
  String _chartType;
  List<Series> _series;

  String get chartName => _chartName;

  String get chartType => _chartType;

  List<Series> get series => _series;

  ChartModel.fromJson(Map<String, dynamic> parsedJson) {
    _chartName = parsedJson['name'];
    _chartType = parsedJson['type'];
    var list = parsedJson['series'] as List;

    switch (_chartType) {
      case 'Bar':
        _series = list.map((i) => BarSeries.fromJson(i)).toList();
        break;
      case 'Circle':
        _series = list.map((i) => CircleSeries.fromJson(i)).toList();
        break;
      default:
        _series = list.map((i) => UnknownSeries.fromJson(i)).toList();
        break;
    }
  }

  Map<String, dynamic> toJson() {
    print(jsonEncode(_series));

    return {
      'name': _chartName,
      'type': _chartType,
      'series': jsonEncode(_series),
    };
  }
}
