import 'package:rxdart/rxdart.dart';
import '../resources/Filter.dart';

class FilterBloc {
  final Filter filter;
  final fetcher = BehaviorSubject<Filter>();
  final String defaultSelectedKey;

  String _tempSelectedKey = null;

  Observable<Filter> get data => fetcher.stream;

  FilterBloc( { this.filter, this.defaultSelectedKey } ) {
    filter.selectedKey = filter.selectedKey ?? defaultSelectedKey;
  }

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
       filter.filterTemp[k] = (k == id);
    });

    fetcher.add(filter);
  }

  setDefaultFilter({ bool isCustom = false }) {
    _tempSelectedKey = defaultSelectedKey;
    filter.filterTemp.forEach((k, v) {
      if (isCustom) {
        filter.filterTemp[k] = (k == defaultSelectedKey);
      } else {
        filter.filterTemp[k] = true;
      }
    });

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