import 'package:arch/arch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';

part 'wash.g.dart';

@JsonSerializable()
class Wash implements BaseWash {
  @override
  @JsonKey(name: 'SurveyYear') //Year
  final int surveyYear;
  @override
  @JsonKey(name: "DistrictCode") //DistrictCode
  final String districtCode;

  @JsonKey(name: 'District', defaultValue: '') //GNP
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

  @JsonKey(name: 'Answer', defaultValue: '') //Ed Expense A
  final String answer;

  @JsonKey(name: 'Response', defaultValue: '') //Ed Expense A
  final String response;

  @JsonKey(name: 'Num', defaultValue: 0) //Ed Expense B
  final int number;

  @JsonKey(name: 'NumThisYear', defaultValue: 0)
  final int numThisYear;

  const Wash(
    this.surveyYear,
    this.districtCode,
    this.district,
    this.authorityCode,
    this.authority,
    this.authorityGroupCode,
    this.authorityGroup,
    this.schoolTypeCode,
    this.schoolType,
    this.question,
    this.answer,
    this.response,
    this.number,
    this.numThisYear,
  );

  factory Wash.fromJson(Map<String, dynamic> json) => _$WashFromJson(json);

  Map<String, dynamic> toJson() => _$WashToJson(this);
}