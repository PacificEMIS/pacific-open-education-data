import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'emises_config.g.dart';

abstract class EmisesConfig
    implements Built<EmisesConfig, EmisesConfigBuilder> {
  EmisesConfig._();

  factory EmisesConfig([updates(EmisesConfigBuilder b)]) = _$EmisesConfig;

  @BuiltValueField(wireName: 'emises')
  BuiltList<EmisConfig> get emises;

  String toJson() {
    return json
        .encode(standardSerializers.serializeWith(EmisesConfig.serializer, this));
  }

  static EmisesConfig fromJson(String jsonString) {
    return standardSerializers.deserializeWith(
        EmisesConfig.serializer, json.decode(jsonString));
  }

  static Serializer<EmisesConfig> get serializer => _$emisesConfigSerializer;

  EmisConfig getEmisConfigFor(Emis emis) {
    return emises.firstWhere((it) => it.id == emis.key, orElse: () => null);
  }
}

extension _EmisKey on Emis {
  String get key {
    switch (this) {
      case Emis.miemis:
        return 'miemis';
      case Emis.fedemis:
        return 'fedemis';
      case Emis.kemis:
        return 'kemis';
    }
    throw FallThroughError();
  }
}