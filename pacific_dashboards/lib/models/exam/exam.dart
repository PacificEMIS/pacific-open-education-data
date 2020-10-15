import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

@JsonSerializable()
class Exam {
  @JsonKey(name: 'Exam')
  final String name;

  @JsonKey(name: 'ExamYear')
  final int year;

  @JsonKey(name: 'DistrictCode')
  final String districtCode;

  @JsonKey(name: 'ExamStandard')
  final String standard;

  @JsonKey(name: 'ExamBenchmark')
  final String benchmark;

  @JsonKey(name: 'CandidatesM', defaultValue: 0)
  final int candidatesM;

  @JsonKey(name: '1M', defaultValue: 0)
  final int wellBelowCompetentM;

  @JsonKey(name: 'ApproachingCompetenceM', defaultValue: 0)
  final int approachingCompetenceM;

  @JsonKey(name: 'MinimallyCompetentM', defaultValue: 0)
  final int minimallyCompetentM;

  @JsonKey(name: 'CompetentM', defaultValue: 0)
  final int competentM;

  @JsonKey(name: 'CandidatesF', defaultValue: 0)
  final int candidatesF;

  @JsonKey(name: 'WellBelowCompetentF', defaultValue: 0)
  final int wellBelowCompetentF;

  @JsonKey(name: 'ApproachingCompetenceF', defaultValue: 0)
  final int approachingCompetenceF;

  @JsonKey(name: 'MinimallyCompetentF', defaultValue: 0)
  final int minimallyCompetentF;

  @JsonKey(name: 'CompetentF', defaultValue: 0)
  final int competentF;

  const Exam({
    @required this.name,
    @required this.year,
    @required this.districtCode,
    @required this.standard,
    @required this.benchmark,
    @required this.candidatesM,
    @required this.wellBelowCompetentM,
    @required this.approachingCompetenceM,
    @required this.minimallyCompetentM,
    @required this.competentM,
    @required this.candidatesF,
    @required this.wellBelowCompetentF,
    @required this.approachingCompetenceF,
    @required this.minimallyCompetentF,
    @required this.competentF,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  Map<String, dynamic> toJson() => _$ExamToJson(this);

  Exam operator +(Exam other) {
    return Exam(
      name: name,
      year: year,
      districtCode: districtCode,
      standard: standard,
      benchmark: benchmark,
      candidatesM: candidatesM + other.candidatesM,
      wellBelowCompetentM: wellBelowCompetentM + other.wellBelowCompetentM,
      approachingCompetenceM:
          approachingCompetenceM + other.approachingCompetenceM,
      minimallyCompetentM: minimallyCompetentM + other.minimallyCompetentM,
      competentM: competentM + other.competentM,
      candidatesF: candidatesF + other.candidatesF,
      wellBelowCompetentF: wellBelowCompetentF + other.wellBelowCompetentF,
      approachingCompetenceF:
          approachingCompetenceF + other.approachingCompetenceF,
      minimallyCompetentF: minimallyCompetentF + other.minimallyCompetentF,
      competentF: competentF + other.competentF,
    );
  }
}
