import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/double_json.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';
import 'package:pacific_dashboards/models/json_converters/string_json.dart';

part 'indicators_sector_by_level.g.dart';

@JsonSerializable()
class IndicatorsSectorByLevel {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'sectorCode')
  final String sectorCode;

  //"teachersM":512,
  @JsonKey(name: 'teachersM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int teachersMale;

  //"teachersF":584,
  @JsonKey(name: 'teachersF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int teachersFemale;

  //"teachers":1096,
  @JsonKey(name: 'teachers',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int teachers;

  //"certM":11,
  @JsonKey(name: 'certM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certifiedMale;

  //"certF":20,
  @JsonKey(name: 'certF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certifiedFemale;

  //"cert":31,
  @JsonKey(name: 'cert',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certified;

  //"qualM":436,
  @JsonKey(name: 'qualM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int qualifiedMale;

  //"qualF":503,
  @JsonKey(name: 'qualF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int qualifiedFemale;

  //"qual":939,
  @JsonKey(name: 'qual',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int qualified;

  //"certQualM":9,
  @JsonKey(name: 'certQualM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certQualMale;

  //"certQualF":19,
  @JsonKey(name: 'certQualF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certQualFemale;

  //"certQual":28,
  @JsonKey(name: 'certQual',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int certQual;

  //"enrolM":9610,
  @JsonKey(name: 'enrolM',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolmentMale;

  //"enrolF":8985,
  @JsonKey(name: 'enrolF',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolmentFemale;

  //"enrol":18595,
  @JsonKey(name: 'enrol',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int enrolment;

  //"certPercM":0.021,
  @JsonKey(name: 'certPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercentMale;

  //"certPercF":0.034,
  @JsonKey(name: 'certPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercentFemale;

  //"certPerc":0.028,
  @JsonKey(name: 'certPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certifiedPercent;

  //"qualPercM":0.852,
  @JsonKey(name: 'qualPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercentMale;

  //"qualPercF":0.861,
  @JsonKey(name: 'qualPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercentFemale;

  //"qualPerc":0.857,
  @JsonKey(name: 'qualPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double qualifiedPercent;

  //"certQualPercM":0.018,
  @JsonKey(name: 'certQualPercM',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercentMale;

  //"certQualPercF":0.033,
  @JsonKey(name: 'certQualPercF',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercentFemale;

  //"certQualPerc":0.026,
  @JsonKey(name: 'certQualPerc',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double certQualPercent;

  //"PTR":16.966,
  @JsonKey(name: 'PTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatio;

  //"certPTR":599.839,
  @JsonKey(name: 'certPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioCertified;

  //"qualPTR":19.803,
  @JsonKey(name: 'qualPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioQualified;

  //"certQualPTR":664.107
  @JsonKey(name: 'certQualPTR',
      toJson: DoubleJson.doubleToJson,
      fromJson: DoubleJson.doubleFromJson,
      includeIfNull: false)
  final double pupilTeacherRatioCertQual;


  const IndicatorsSectorByLevel({
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

  factory IndicatorsSectorByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsSectorByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSectorByLevelToJson(this);
}