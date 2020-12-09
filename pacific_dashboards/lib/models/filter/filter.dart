import 'package:flutter/foundation.dart';

class FilterItem {
  const FilterItem(this.value, this.visibleName);

  final String visibleName;
  final Object value;
}

class Filter {
  Filter({
    @required this.id,
    @required this.title,
    @required this.items,
    @required this.selectedIndex,
  });

  final int id;

  final String title;

  final List<FilterItem> items;

  int selectedIndex;

  bool get isDefault => items[selectedIndex].value == null;

  int get intValue => items[selectedIndex].value as int;

  String get stringValue => items[selectedIndex].value as String;
}
