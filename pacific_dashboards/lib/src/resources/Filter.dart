class Filter {

  Map<String, bool> _filter = Map<String, bool>();
  String filterName;
  String selectedKey = "";
  Map<String, bool> filterTemp = Map<String, bool>();

  Filter(Set filterOptions, String name) {
    _filter = new Map.fromIterable(filterOptions, key: (i) => i, value: (i) => true);
    filterName = name;
  }

  Map<String, bool> getFilter() {
    return _filter;
  }

  bool containsKey(String key) {
    return _filter.containsKey(key);
  }

  void generateNewTempFilter() {
    filterTemp = new Map<String, bool>();
    filterTemp.addAll(_filter);
  }

  void applyFilter() {
    _filter = filterTemp;
  }

  bool isEnabledInFilter(String key) {
    return !(_filter.containsKey(key) && !_filter[key]);
  }

  String getMax() {
    var max = "0";
    _filter.forEach((k, v) {
      if (int.parse(k) > int.parse(max)) {
        max = k;
      }
    });
    return max;
  }

  void selectMax() {
    var max = getMax();
    _filter[max] = false;
    _filter.forEach((k, v) {
      _filter[k] = k == max;
    });
  }
}