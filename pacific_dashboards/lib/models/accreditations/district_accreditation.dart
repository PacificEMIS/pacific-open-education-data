import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';

part 'district_accreditation.g.dart';

@JsonSerializable()
class DistrictAccreditation implements Accreditation {
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

  @JsonKey(name: 'InspectionResult')
  final String inspectionResult;

  @JsonKey(name: 'Num', defaultValue: 0)
  @override
  final int total;

  @JsonKey(name: 'NumThisYear', defaultValue: 0)
  @override
  final int numThisYear;

  const DistrictAccreditation({
    @required this.surveyYear,
    @required this.districtCode,
    @required this.authorityCode,
    @required this.authorityGovtCode,
    @required this.schoolTypeCode,
    @required this.schoolType,
    @required this.inspectionResult,
    @required this.total,
    @required this.numThisYear,
  });

  factory DistrictAccreditation.fromJson(Map<String, dynamic> json) =>
      _$DistrictAccreditationFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictAccreditationToJson(this);

  @override
  String get result => inspectionResult;

  @override
  Comparable get sortField => "";
}
