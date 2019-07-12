class Filter {

  Map<String, bool> _filter = Map<String, bool>();
  String filterName;
  Map<String, bool> filterTemp = Map<String, bool>();

  Filter(Set filterOptions, String name) {
    _filter = new Map.fromIterable(filterOptions, key: (i) => i, value: (i) => true);
    filterName = name;
  }

  Map<String, bool> getFilter() {
    return _filter;
  }

  void generateNewTempFilter() {
    filterTemp = new Map<String, bool>();
    filterTemp.addAll(_filter);
  }

  void applyFilter() {
    _filter = filterTemp;
  }

  bool isEnabledInFilter(String key) {
    return !(_filter.containsKey(key) && _filter[key] == false);
  }
}