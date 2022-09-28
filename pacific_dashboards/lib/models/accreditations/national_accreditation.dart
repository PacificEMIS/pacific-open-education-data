import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';

part 'national_accreditation.g.dart';

@JsonSerializable()
class NationalAccreditation implements Accreditation {
  @JsonKey(name: 'SurveyYear', defaultValue: 0)
  @override
  final int surveyYear;

  @JsonKey(name: 'DistrictCode', defaultValue: '')
  @override
  final String districtCode;

  @JsonKey(name: 'District', defaultValue: '')
  final String district;

  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  @override
  final String authorityCode;

  @JsonKey(name: 'Authority', defaultValue: '')
  final String authority;

  @JsonKey(name: 'AuthorityGovtCode', defaultValue: '')
  final String authorityGovtCode;

  @JsonKey(name: 'AuthorityGovt', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'SchoolType', defaultValue: '')
  final String schoolType;

  @JsonKey(name: 'InspectionResult', defaultValue: '')
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
