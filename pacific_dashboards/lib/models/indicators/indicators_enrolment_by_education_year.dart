import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/double_json.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';
import 'package:pacific_dashboards/models/json_converters/string_json.dart';

part 'indicators_enrolment_by_education_year.g.dart';

@JsonSerializable()
class IndicatorsEnrolmentByEducationYear {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'officialAge')
  final String officialAge;

  @JsonKey(name: 'yearOfEd')
  final String yearOfEducation;

  @JsonKey(name: 'levelCode')
  final String levelCode;

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
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolMale;

  @JsonKey(name: 'enrolF',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolFemale;

  @JsonKey(name: 'enrol',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrol;

  @JsonKey(name: 'nEnrolM',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAgeMale;

  @JsonKey(name: 'nEnrolF',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAgeFemale;

  @JsonKey(name: 'nEnrol',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolOfficialAge;

  @JsonKey(name: 'repM',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int repeatersMale;

  @JsonKey(name: 'repF',
      defaultValue: 0,
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int repeatersFemale;

  @JsonKey(name: 'rep',
      defaultValue: 0,
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

  const IndicatorsEnrolmentByEducationYear({
    @required this.year,
    this.officialAge,
    this.yearOfEducation,
    this.levelCode,
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

  factory IndicatorsEnrolmentByEducationYear.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsEnrolmentByEducationYearFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsEnrolmentByEducationYearToJson(this);
}