import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'indicators_survival_by_level.dart';
import 'indicators_teacher_by_level.dart';

part 'indicators_survivals_by_level.g.dart';

@JsonSerializable()
class IndicatorsSurvivalsByLevel {
  @JsonKey(name: 'Survival', defaultValue: [])
  final List<IndicatorsSurvivalByLevel> survivals;

  const IndicatorsSurvivalsByLevel({
    @required this.survivals,
  });

  factory IndicatorsSurvivalsByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsSurvivalsByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSurvivalsByLevelToJson(this);
}