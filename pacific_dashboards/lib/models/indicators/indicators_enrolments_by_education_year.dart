import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_education_year.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';

part 'indicators_enrolments_by_education_year.g.dart';

@JsonSerializable()
class IndicatorsEnrolmentsByEducationYear {
  @JsonKey(name: 'LevelER', defaultValue: [])
  final List<IndicatorsEnrolmentByEducationYear> enrolments;

  const IndicatorsEnrolmentsByEducationYear({
    @required this.enrolments,
  });

  factory IndicatorsEnrolmentsByEducationYear.fromJson(Map<String, dynamic> json) => _$IndicatorsEnrolmentsByEducationYearFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsEnrolmentsByEducationYearToJson(this);
}