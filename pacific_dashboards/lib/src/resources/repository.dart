import 'dart:async';

import '../models/item_model.dart';
import 'charts_api_provider.dart';

class Repository {
  final chartsApiProvider = ChartsApiProvider();

  Future<ItemModel> fetchAllCharts() => chartsApiProvider.fetchChartsList();
}
