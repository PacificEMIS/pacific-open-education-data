import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';

part 'national_accreditation.g.dart';

@JsonSerializable()
class NationalAccreditation implements Accreditation {
  @JsonKey(name: 'SurveyYear')
  @override
  final int surveyYear;

  @JsonKey(name: 'DistrictCode')
  @override
  final String districtCode;

  @JsonKey(name: 'District')
  @override
  final String district;

  @JsonKey(name: 'AuthorityCode')
  @override
  final String authorityCode;

  @JsonKey(name: 'Authority')
  @override
  final String authority;

  @JsonKey(name: 'AuthorityGovtCode')
  final String authorityGovtCode;

  @JsonKey(name: 'AuthorityGovt')
  final String authorityGovt;

  @JsonKey(name: 'SchoolTypeCode')
  final String schoolTypeCode;

  @JsonKey(name: 'SchoolType')
  final String schoolType;

  @JsonKey(name: 'InspectionResult')
  final String inspectionResult;

  @JsonKey(name: 'Num', defaultValue: 0)
  @override
  final int total;

  @JsonKey(name: 'NumThisYear', defaultValue: 0)
  @override
  final int numThisYear;

  const NationalAccreditation({
    this.surveyYear,
    this.districtCode,
    this.district,
    this.authorityCode,
    this.authority,
    this.authorityGovtCode,
    this.authorityGovt,
    this.schoolTypeCode,
    this.schoolType,
    this.inspectionResult,
    this.total,
    this.numThisYear,
  });

  factory NationalAccreditation.fromJson(Map<String, dynamic> json) =>
      _$NationalAccreditationFromJson(json);

  Map<String, dynamic> toJson() => _$NationalAccreditationToJson(this);

  @override
  String get result => inspectionResult;

  @override
  Comparable get sortField => "";
}
