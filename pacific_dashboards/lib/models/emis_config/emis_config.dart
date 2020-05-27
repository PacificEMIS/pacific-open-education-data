import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/emis_config/module_config.dart';
import 'package:pacific_dashboards/pages/home/section.dart';

part 'emis_config.g.dart';

@JsonSerializable()
class EmisConfig {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'modules')
  final List<ModuleConfig> modules;

  const EmisConfig({
    @required this.id,
    @required this.modules,
  });

  factory EmisConfig.fromJson(Map<String, dynamic> json) =>
      _$EmisConfigFromJson(json);

  Map<String, dynamic> toJson() => _$EmisConfigToJson(this);

  ModuleConfig moduleConfigFor(Section section) {
    return modules.firstWhere((it) => it.asSection() == section,
        orElse: () => null);
  }
}
