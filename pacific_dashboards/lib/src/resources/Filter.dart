class Filter {

  Map<String, bool> _filter = Map<String, bool>();
  String filterName;

  Filter(Set filterOptions, String name) {
    _filter = new Map.fromIterable(filterOptions, key: (i) => i, value: (i) => true);
    filterName = name;
  }

  Map<String, bool> getFilter() {
    return _filter;
  }

  void setFilter(Map<String, bool> filter) {
    _filter = filter;
  }

  bool isEnabledInFilter(String key) {
    return !(_filter.containsKey(key) && _filter[key] == false);
  }
}