import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/double_json.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';
import 'package:pacific_dashboards/models/json_converters/string_json.dart';

part 'indicators_teacher_by_level.g.dart';

@JsonSerializable()
class IndicatorsTeacherByLevel {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'edLevelCode')
  final String sectorCode;

  //"ftptM":204.468804,
  @JsonKey(name: 'ftptM',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int teachersMale;

  //"ftptF":201.089682,
  @JsonKey(name: 'ftptF',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int teachersFemale;

  //"ftpt":405.558486,
  @JsonKey(name: 'ftpt',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int teachers;

  //"ftptcM":57.066667,
  @JsonKey(name: 'ftptcM',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certifiedMale;

  //"ftptcF":65.642857,
  @JsonKey(name: 'ftptcF',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certifiedFemale;

  //"ftptc":122.709524,
  @JsonKey(name: 'ftptc',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certified;

  //"ftptqM":194.357693,
  @JsonKey(name: 'ftptqM',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int qualifiedMale;

  //"ftptqF":192.811905,
  @JsonKey(name: 'ftptqF',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int qualifiedFemale;

  //"ftptq":387.169598,
  @JsonKey(name: 'ftptq',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int qualified;

  //"ftptqcM":57.066667,
  @JsonKey(name: 'ftptqcM',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certQualMale;

  //"ftptqcF":65.642857,
  @JsonKey(name: 'ftptqcF',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certQualFemale;

  //"ftptqc":122.709524,
  @JsonKey(name: 'ftptqc',
      toJson: IntJson.intToJson,
      fromJson: DoubleJson.intFromDoubleJson,
      includeIfNull: false)
  final int certQual;

  //"enrolM":2730,
  @JsonKey(name: 'enrolM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolmentMale;

  //"enrolF":3026,
  @JsonKey(name: 'enrolF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolmentFemale;

  //"enrol":5756,
  @JsonKey(name: 'enrol',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolment;

  //"ftptCPercM":0.2790971819838101,
  @JsonKey(name: 'ftptCPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercentMale;

  //"ftptCPercF":0.32643572930808057,
  @JsonKey(name: 'ftptCPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercentFemale;

  //"ftptCPerc":0.3025692427503539,
  @JsonKey(name: 'ftptCPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercent;

  //"ftptQPercM":0.9505493708468115,
  @JsonKey(name: 'ftptQPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercentMale;

  //"ftptQPercF":0.9588353966366111,
  @JsonKey(name: 'ftptQPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercentFemale;

  //"ftptQPerc":0.9546578640694502,
  @JsonKey(name: 'ftptQPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercent;

  //"ftptQCPercM":0.2790971819838101,
  @JsonKey(name: 'ftptQCPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercentMale;

  //"ftptQCPercF":0.32643572930808057,
  @JsonKey(name: 'ftptQCPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercentFemale;

  //"ftptQCPerc":0.3025692427503539,
  @JsonKey(name: 'ftptQCPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercent;

  //"ftptPTR":14.192774,
  @JsonKey(name: 'ftptPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatio;

  //"ftptcPTR":46.907524,
  @JsonKey(name: 'ftptcPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioCertified;

  //"ftptqPTR":14.86687,
  @JsonKey(name: 'ftptqPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioQualified;

  //"ftptqcPTR":46.907524,
  @JsonKey(name: 'ftptqcPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioCertQual;


  const IndicatorsTeacherByLevel({
    @required this.year,
    @required this.sectorCode,
    this.teachersMale,
    this.teachersFemale,
    this.teachers,
    this.certifiedMale,
    this.certifiedFemale,
    this.certified,
    this.qualifiedMale,
    this.qualifiedFemale,
    this.qualified,
    this.certQualMale,
    this.certQualFemale,
    this.certQual,
    this.enrolmentMale,
    this.enrolmentFemale,
    this.enrolment,
    this.certifiedPercentMale,
    this.certifiedPercentFemale,
    this.certifiedPercent,
    this.qualifiedPercentMale,
    this.qualifiedPercentFemale,
    this.qualifiedPercent,
    this.certQualPercentMale,
    this.certQualPercentFemale,
    this.certQualPercent,
    this.pupilTeacherRatio,
    this.pupilTeacherRatioCertified,
    this.pupilTeacherRatioQualified,
    this.pupilTeacherRatioCertQual
  });

  factory IndicatorsTeacherByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsTeacherByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsTeacherByLevelToJson(this);
}