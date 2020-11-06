import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolments_by_level.dart';
import 'package:pacific_dashboards/models/indicators/indicators_school_counts.dart';

part 'indicators.g.dart';

@JsonSerializable()
class Indicators {
  @JsonKey(name: 'SchoolCounts')
  final IndicatorsSchoolCounts schoolCounts;

  @JsonKey(name: 'ERs')
  final IndicatorsEnrolmentsByLevel enrolments;

  const Indicators({
    @required this.schoolCounts,
    @required this.enrolments,
  });

  factory Indicators.fromJson(Map<String, dynamic> json) => _$IndicatorsFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsToJson(this);
}