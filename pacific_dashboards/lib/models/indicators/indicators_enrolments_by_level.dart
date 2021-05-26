import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';

part 'indicators_enrolments_by_level.g.dart';

@JsonSerializable()
class IndicatorsEnrolmentsByLevel {
  @JsonKey(name: 'ER')
  final List<IndicatorsEnrolmentByLevel> enrolments;

  const IndicatorsEnrolmentsByLevel({
    @required this.enrolments,
  });

  factory IndicatorsEnrolmentsByLevel.fromJson(Map<String, dynamic> json) => _$IndicatorsEnrolmentsByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsEnrolmentsByLevelToJson(this);
}