import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'lookup.g.dart';

abstract class Lookup implements Built<Lookup, LookupBuilder> {
  Lookup._();

  factory Lookup([updates(LookupBuilder b)]) = _$Lookup;

  @BuiltValueField(wireName: 'C')
  String get code;

  @BuiltValueField(wireName: 'N')
  String get name;

  String toJson() {
    return json
        .encode(standardSerializers.serializeWith(Lookup.serializer, this));
  }

  static Lookup fromJson(String jsonString) {
    return standardSerializers.deserializeWith(
        Lookup.serializer, json.decode(jsonString));
  }

  static Serializer<Lookup> get serializer => _$lookupSerializer;
}