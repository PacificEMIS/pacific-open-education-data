import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/item_model.dart';

class ChartsBloc {
  final _repository = Repository();
  final _chartsFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allCharts => _chartsFetcher.stream;

  fetchAllCharts() async {
    var itemModel = await _repository.fetchAllCharts();
    _chartsFetcher.sink.add(itemModel);
  }

  dispose() {
    _chartsFetcher.close();
  }
}

final bloc = ChartsBloc();
