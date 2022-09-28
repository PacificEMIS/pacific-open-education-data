import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'indicators_teacher_by_level.dart';

part 'indicators_teachers_by_level.g.dart';

@JsonSerializable()
class IndicatorsTeachersByLevel {
  @JsonKey(name: 'EdLevel', defaultValue: [])
  final List<IndicatorsTeacherByLevel> levels;

  const IndicatorsTeachersByLevel({
    @required this.levels,
  });

  factory IndicatorsTeachersByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsTeachersByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsTeachersByLevelToJson(this);
}