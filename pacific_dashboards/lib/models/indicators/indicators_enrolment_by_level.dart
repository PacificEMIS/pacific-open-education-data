import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/double_json.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';
import 'package:pacific_dashboards/models/json_converters/string_json.dart';

part 'indicators_enrolment_by_level.g.dart';

@JsonSerializable()
class IndicatorsEnrolmentByLevel {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'edLevelCode')
  final String educationLevelCode;

  @JsonKey(name: 'firstYear')
  final String firstYear;

  @JsonKey(name: 'lastYear')
  final String lastYear;

  @JsonKey(name: 'numYears')
  final String numYears;

  @JsonKey(name: 'startAge')
  final String startAge;

  @JsonKey(name: 'popM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int populationMale;

  @JsonKey(name: 'popF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int populationFemale;

  @JsonKey(name: 'pop',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int population;

  @JsonKey(name: 'enrolM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolMale;

  @JsonKey(name: 'enrolF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolFemale;

  @JsonKey(name: 'enrol',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrol;

  @JsonKey(name: 'nEnrolM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAgeMale;

  @JsonKey(name: 'nEnrolF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAgeFemale;

  @JsonKey(name: 'nEnrol',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAge;

  @JsonKey(name: 'repM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int repeatersMale;

  @JsonKey(name: 'repF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int repeatersFemale;

  @JsonKey(name: 'rep',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int repeaters;

  @JsonKey(name: 'nRepM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netRepeatersMale;

  @JsonKey(name: 'nRepF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netRepeatersFemale;

  @JsonKey(name: 'nRep',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netRepeaters;

  @JsonKey(name: 'intakeM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int intakeMale;

  @JsonKey(name: 'intakeF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int intakeFemale;

  @JsonKey(name: 'intake',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int intake;

  @JsonKey(name: 'nIntakeM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netIntakeMale;

  @JsonKey(name: 'nIntakeF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netIntakeFemale;

  @JsonKey(name: 'nIntake',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int netIntake;

  @JsonKey(name: 'gerM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossEnrolmentRatioMale;

  @JsonKey(name: 'gerF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossEnrolmentRatioFemale;

  @JsonKey(name: 'ger',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossEnrolmentRatio;

  @JsonKey(name: 'nerM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netEnrolmentRatioMale;

  @JsonKey(name: 'nerF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netEnrolmentRatioFemale;

  @JsonKey(name: 'ner',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netEnrolmentRatio;

  @JsonKey(name: 'girM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossIntakeRatioMale;

  @JsonKey(name: 'girF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossIntakeRatioFemale;

  @JsonKey(name: 'gir',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double grossIntakeRatio;

  @JsonKey(name: 'nirM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netIntakeRatioMale;

  @JsonKey(name: 'nirF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netIntakeRatioFemale;

  @JsonKey(name: 'nir',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double netIntakeRatio;

  const IndicatorsEnrolmentByLevel({
    @required this.year,
    @required this.educationLevelCode,
    this.firstYear,
    this.lastYear,
    this.numYears,
    this.startAge,
    this.populationMale,
    this.populationFemale,
    this.population,
    this.enrolMale,
    this.enrolFemale,
    this.enrol,
    this.enrolOfficialAgeMale,
    this.enrolOfficialAgeFemale,
    this.enrolOfficialAge,
    this.repeatersMale,
    this.repeatersFemale,
    this.repeaters,
    this.netRepeatersMale,
    this.netRepeatersFemale,
    this.netRepeaters,
    this.intakeMale,
    this.intakeFemale,
    this.intake,
    this.netIntakeMale,
    this.netIntakeFemale,
    this.netIntake,
    this.grossEnrolmentRatioMale,
    this.grossEnrolmentRatioFemale,
    this.grossEnrolmentRatio,
    this.netEnrolmentRatioMale,
    this.netEnrolmentRatioFemale,
    this.netEnrolmentRatio,
    this.grossIntakeRatioMale,
    this.grossIntakeRatioFemale,
    this.grossIntakeRatio,
    this.netIntakeRatioMale,
    this.netIntakeRatioFemale,
    this.netIntakeRatio,
  });

  factory IndicatorsEnrolmentByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsEnrolmentByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsEnrolmentByLevelToJson(this);

  int get yearsOfSchooling {
    return numYears != null ? int.tryParse(numYears) : null;
  }

  int get officialStartAge {
    return startAge != null ? int.tryParse(startAge) : null;
  }

  bool isSchoolOfLevel(int educationYear) {
    int start = int.tryParse(firstYear);
    int end = int.tryParse(lastYear);
    if (start == null || end == null) return false;
    return educationYear >= start && educationYear <= end;
  }
}