import 'package:pacific_dashboards/src/resources/Filter.dart';
import 'package:rxdart/rxdart.dart';

class FilterBloc {
  final Filter filter;
  final _fetcher = BehaviorSubject<Filter>();
  final String defaultSelectedKey;

  String _tempSelectedKey = "";

  Observable<Filter> get data => _fetcher.stream;

  FilterBloc({this.filter, this.defaultSelectedKey});

  initialize() {
    if (filter.selectedKey == "") {
      filter.selectedKey = defaultSelectedKey;
      setDefaultFilter();
      applyChanges();
    }
  }

  String get selectedKey =>
      _tempSelectedKey.isNotEmpty ? _tempSelectedKey : filter.selectedKey;

  fetchData() {
    filter.generateNewTempFilter();
    _fetcher.add(filter);
  }

  changeSelectedById(String id) {
    _tempSelectedKey = id;
    filter.filterTemp.forEach((k, v) {
      filter.filterTemp[k] = (k == id);
    });

    _fetcher.add(filter);
  }

  setDefaultFilter() {
    _tempSelectedKey = defaultSelectedKey;
    var isCustom = filter.containsKey(_tempSelectedKey);
    filter.filterTemp.forEach((k, v) {
      filter.filterTemp[k] = !isCustom || (k == defaultSelectedKey);
    });

    _fetcher.add(filter);
  }

  applyChanges() {
    filter.selectedKey = selectedKey;
    filter.applyFilter();
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}
