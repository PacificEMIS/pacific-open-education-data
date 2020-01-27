import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/emis_config/module_config.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'emis_config.g.dart';

abstract class EmisConfig implements Built<EmisConfig, EmisConfigBuilder> {
  EmisConfig._();

  factory EmisConfig([updates(EmisConfigBuilder b)]) = _$EmisConfig;

  @BuiltValueField(wireName: 'id')
  String get id;

  @BuiltValueField(wireName: 'modules')
  BuiltList<ModuleConfig> get modules;

  String toJson() {
    return json.encode(standardSerializers.serializeWith(EmisConfig.serializer, this));
  }

  static EmisConfig fromJson(String jsonString) {
    return standardSerializers.deserializeWith(
        EmisConfig.serializer, json.decode(jsonString));
  }

  static Serializer<EmisConfig> get serializer => _$emisConfigSerializer;
}