import 'package:flutter/foundation.dart';

class FilterItem {
  final String visibleName;
  final Object value;

  const FilterItem(this.value, this.visibleName);
}

class Filter {
  final int id;

  final String title;

  final List<FilterItem> items;

  int selectedIndex;

  Filter({
    @required this.id,
    @required this.title,
    @required this.items,
    @required this.selectedIndex,
  });

  bool get isDefault => items[selectedIndex].value == null;

  int get intValue => items[selectedIndex].value as int;

  String get stringValue => items[selectedIndex].value as String;

  Filter clone() =>
      Filter(
          title: title,
          selectedIndex: selectedIndex,
          id: id,
          items: items
      );
}
