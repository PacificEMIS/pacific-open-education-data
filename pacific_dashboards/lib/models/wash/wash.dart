import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';

part 'wash.g.dart';

@JsonSerializable()
class Wash implements BaseWash {
  @override
  @JsonKey(name: 'SurveyYear')
  final int surveyYear;

  @override
  @JsonKey(name: "DistrictCode") 
  final String districtCode;

  @JsonKey(name: 'District', defaultValue: '')
  final String district;

  @override
  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'Authority', defaultValue: '')
  final String authority;

  @JsonKey(name: 'AuthorityGroupCode', defaultValue: '')
  final String authorityGroupCode;

  @JsonKey(name: 'AuthorityGroup', defaultValue: '')
  final String authorityGroup;

  @override
  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'SchoolType', defaultValue: '')
  final String schoolType;

  @JsonKey(name: 'Question', defaultValue: 0)
  final String question;

  @JsonKey(name: 'Answer')
  final String answer;

  @JsonKey(name: 'Response')
  final String response;

  @JsonKey(name: 'Item')
  final String item;

  @JsonKey(name: 'Num', defaultValue: 0)
  final int number;

  @JsonKey(name: 'NumThisYear', defaultValue: 0)
  final int numThisYear;

  String get result => answer ?? response ?? item ?? '';

  const Wash({
    @required this.surveyYear,
    @required this.districtCode,
    @required this.district,
    @required this.authorityCode,
    @required this.authority,
    @required this.authorityGroupCode,
    @required this.authorityGroup,
    @required this.schoolTypeCode,
    @required this.schoolType,
    @required this.question,
    @required this.answer,
    @required this.response,
    @required this.item,
    @required this.number,
    @required this.numThisYear,
  });

  factory Wash.fromJson(Map<String, dynamic> json) => _$WashFromJson(json);

  Map<String, dynamic> toJson() => _$WashToJson(this);
}