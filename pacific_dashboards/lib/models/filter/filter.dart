import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'filter.g.dart';

class FilterItem {
  final String visibleName;
  final Object value;

  const FilterItem(this.value, this.visibleName);
}

abstract class Filter implements Built<Filter, FilterBuilder> {

  Filter._();

  factory Filter([updates(FilterBuilder b)]) = _$Filter;

  @BuiltValueField(wireName: 'C')
  int get id;

  @BuiltValueField(wireName: 'C')
  String get title;

  @BuiltValueField(wireName: 'C')
  BuiltList<FilterItem> get items;

  @BuiltValueField(wireName: 'C')
  int get selectedIndex;

  String toJson() {
    return json
        .encode(serializers.serializeWith(Filter.serializer, this));
  }

  static Filter fromJson(String jsonString) {
    return serializers.deserializeWith(
        Filter.serializer, json.decode(jsonString));
  }

  static Serializer<Filter> get serializer => _$filterSerializer;


  bool get isDefault => items[selectedIndex].value == null;

  int get intValue => items[selectedIndex].value as int;

  String get stringValue => items[selectedIndex].value as String;
}