import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam_separated.g.dart';

@JsonSerializable()
class ExamSeparated {
  @JsonKey(name: 'examCode', defaultValue: '')
  final String name;

  @JsonKey(name: 'examYear', defaultValue: '')
  final int year;

  @JsonKey(name: 'Gender', defaultValue: '')
  final String gender;

  @JsonKey(name: 'DistrictCode', defaultValue: '')
  final String districtCode;

  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovtCode', defaultValue: '')
  final String authorityGovtCode;

  @JsonKey(name: 'RecordType', defaultValue: '')
  final String recordType;

  @JsonKey(name: 'Key', defaultValue: '')
  final String key;

  @JsonKey(name: 'Description', defaultValue: '')
  final String description;

  @JsonKey(name: 'achievementLevel', defaultValue: 0)
  final int achievementLevel;

  @JsonKey(name: 'candidateCount', defaultValue: 0)
  final int candidateCount;

  @JsonKey(name: 'indicatorCount', defaultValue: 0)
  final int indicatorCount;

  @JsonKey(name: 'weight', defaultValue: 0.0)
  final double weight;

  const ExamSeparated({
    @required this.name,
    @required this.year,
    @required this.gender,
    @required this.districtCode,
    @required this.schoolTypeCode,
    @required this.authorityCode,
    @required this.authorityGovtCode,
    @required this.recordType,
    @required this.key,
    @required this.description,
    @required this.achievementLevel,
    @required this.candidateCount,
    @required this.indicatorCount,
    @required this.weight,
  });

  factory ExamSeparated.fromJson(Map<String, dynamic> json) => _$ExamSeparatedFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSeparatedToJson(this);

  ExamSeparated operator +(ExamSeparated other) {
    return ExamSeparated(
      name: name,
      year: year,
      gender: gender,
      districtCode: districtCode,
      schoolTypeCode: schoolTypeCode,
      authorityCode: authorityCode,
      authorityGovtCode: authorityGovtCode,
      recordType: recordType,
      key: key,
      description: description,
      achievementLevel: achievementLevel,
      candidateCount: candidateCount + other.candidateCount,
      indicatorCount: indicatorCount + other.indicatorCount,
      weight: weight + other.weight,
    );
  }

  num modeParameter(int mode) {
    switch (mode) {
      case 1:
        return indicatorCount;
      case 2:
        return weight;
      default:
        return candidateCount;
    }
  }
}
