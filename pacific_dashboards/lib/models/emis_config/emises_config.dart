import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';

part 'emises_config.g.dart';

@JsonSerializable()
class EmisesConfig {
  const EmisesConfig(this.emises);

  factory EmisesConfig.fromJson(Map<String, dynamic> json) =>
      _$EmisesConfigFromJson(json);

  @JsonKey(name: 'emises')
  final List<EmisConfig> emises;

  Map<String, dynamic> toJson() => _$EmisesConfigToJson(this);

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
