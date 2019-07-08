import 'package:rxdart/rxdart.dart';
import '../models/TeachersModel.dart';
import '../resources/Filter.dart';

import 'BaseBloc.dart';

class FilterBloc {

  final Filter filter;
  final fetcher = BehaviorSubject<Filter>();

  Observable<Filter> get data => fetcher.stream;

  FilterBloc( { this.filter } );

  fetchData() {
    filter.generateNewTempFilter();
    fetcher.add(filter);
  }

  changeOne(String id, bool value) {
    filter.filterTemp[id] = value;
    fetcher.add(filter);
  }

  changeAll(bool value) {
    filter.filterTemp.forEach((k, v) => filter.filterTemp[k] = value);
    fetcher.add(filter);
  }

  applyChanges() {
    filter.applyFilter();
  }

  dispose() {
    fetcher.close();
  }
}