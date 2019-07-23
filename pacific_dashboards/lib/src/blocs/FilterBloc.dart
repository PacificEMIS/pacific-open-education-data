import 'package:rxdart/rxdart.dart';
import '../models/TeachersModel.dart';
import '../resources/Filter.dart';

import 'BaseBloc.dart';

class FilterBloc {

  final Filter filter;
  final fetcher = BehaviorSubject<Filter>();

  String _tempSelectedKey = null;

  Observable<Filter> get data => fetcher.stream;

  FilterBloc( { this.filter } );

  String getSelectedKey() {
    return _tempSelectedKey ?? filter.selectedKey;
  }

  fetchData() {
    filter.generateNewTempFilter();
    fetcher.add(filter);
  }

  changeSelectedById(String id) {
    _tempSelectedKey = id;
    filter.filterTemp.forEach((k, v) {
     if (k == id) {
       filter.filterTemp[k] = true;
       print("$v");
     } else {
       filter.filterTemp[k] = false;
     }
    });

    fetcher.add(filter);
  }

  changeAll(String value) {
    _tempSelectedKey = 'Select all';
    filter.filterTemp.forEach((k, v) => filter.filterTemp[k] = true);
    fetcher.add(filter);
  }

  applyChanges() {
    filter.selectedKey = _tempSelectedKey;
    filter.applyFilter();
  }

  dispose() {
    fetcher.close();
  }
}