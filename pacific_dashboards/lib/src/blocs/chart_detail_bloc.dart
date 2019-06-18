import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/chart_model.dart';
import '../resources/repository.dart';

class ChartDetailBloc {
  final _repository = Repository();
  final _chartId = PublishSubject<int>();
  final _charts = BehaviorSubject<Future<ChartModel>>();

  Function(int) get fetchChartDetailsById => _chartId.sink.add;

  Observable<Future<ChartModel>> get chartDetails => _charts.stream;

  ChartDetailBloc() {
//    _chartId.stream.transform(streamTransformer)
  }
}
