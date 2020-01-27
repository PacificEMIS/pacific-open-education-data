import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';
import 'package:pacific_dashboards/pages/home/section.dart';

part 'module_config.g.dart';

abstract class ModuleConfig
    implements Built<ModuleConfig, ModuleConfigBuilder> {
  ModuleConfig._();

  factory ModuleConfig([updates(ModuleConfigBuilder b)]) = _$ModuleConfig;

  @BuiltValueField(wireName: 'id')
  String get id;

  @nullable
  @BuiltValueField(wireName: 'note')
  String get note;

  String toJson() {
    return json
        .encode(standardSerializers.serializeWith(ModuleConfig.serializer, this));
  }

  static ModuleConfig fromJson(String jsonString) {
    return standardSerializers.deserializeWith(
        ModuleConfig.serializer, json.decode(jsonString));
  }

  static Serializer<ModuleConfig> get serializer => _$moduleConfigSerializer;

  Section asSection() {
    switch (id) {
      case 'schools':
        return Section.schools;
      case 'teachers':
        return Section.teachers;
      case 'exams':
        return Section.exams;
      case 's_accreditation':
        return Section.schoolAccreditations;
      case 'indicators':
        return Section.indicators;
      case 'budgets':
        return Section.budgets;
    }
    return null;
  }
}
