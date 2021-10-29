import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';

part 'standard_accreditation.g.dart';

@JsonSerializable()
class StandardAccreditation implements Accreditation {
  @JsonKey(name: 'SurveyYear')
  @override
  final int surveyYear;

  @JsonKey(name: 'DistrictCode')
  @override
  final String districtCode;

  @JsonKey(name: 'AuthorityCode')
  @override
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovtCode')
  @override
  final String authorityGovtCode;

  @JsonKey(name: 'SchoolTypeCode')
  final String schoolTypeCode;

  @JsonKey(name: 'SchoolType')
  final String schoolType;

  @JsonKey(name: 'Standard')
  final String standard;

  @JsonKey(name: 'Result')
  @override
  final String result;

  @JsonKey(name: 'Num', defaultValue: 0)
  @override
  final int total;

  @JsonKey(name: 'NumInYear', defaultValue: 0)
  @override
  final int numThisYear;

  const StandardAccreditation({
    @required this.surveyYear,
    @required this.districtCode,
    @required this.authorityCode,
    @required this.authorityGovtCode,
    @required this.schoolTypeCode,
    @required this.schoolType,
    @required this.standard,
    @required this.result,
    @required this.total,
    @required this.numThisYear,
  });

  factory StandardAccreditation.fromJson(Map<String, dynamic> json) =>
      _$StandardAccreditationFromJson(json);

  Map<String, dynamic> toJson() => _$StandardAccreditationToJson(this);

  @override
  Comparable get sortField => standard ?? "";
}
