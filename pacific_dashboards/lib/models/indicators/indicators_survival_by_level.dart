import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/double_json.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';
import 'package:pacific_dashboards/models/json_converters/string_json.dart';

part 'indicators_survival_by_level.g.dart';

@JsonSerializable()
class IndicatorsSurvivalByLevel {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'levelCode')
  final String levelCode;

  @JsonKey(name: 'yearOfEd')
  final String yearOfEducation;

  @JsonKey(name: 'SR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double survivalRate;

  @JsonKey(name: 'SRM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double survivalRateM;

  @JsonKey(name: 'SRF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double survivalRateF;

  const IndicatorsSurvivalByLevel({
    @required this.year,
    @required this.levelCode,
    @required this.yearOfEducation,
    this.survivalRate,
    this.survivalRateM,
    this.survivalRateF,
  });

  factory IndicatorsSurvivalByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsSurvivalByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSurvivalByLevelToJson(this);
}