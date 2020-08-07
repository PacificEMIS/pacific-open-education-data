import 'package:json_annotation/json_annotation.dart';

part 'school_exam_report.g.dart';

@JsonSerializable()
class SchoolExamReport {

  @JsonKey(name: 'examCode')
  String examCode;

  @JsonKey(name: 'examYear')
  int year;

  @JsonKey(name: 'examName')
  String examName;

  @JsonKey(name: 'benchmarkCode')
  String benchmarkCode;

  @JsonKey(name: 'benchmarkDesc')
  String benchmarkDescription;

  @JsonKey(name: 'achievementLevel')
  int achievementLevel;

  @JsonKey(name: 'achievementDesc')
  String achievementDescription;

  @JsonKey(name: 'CandidatesM', defaultValue: 0)
  int maleCandidates;

  @JsonKey(name: 'CandidatesF', defaultValue: 0)
  int femaleCandidates;

  SchoolExamReport();

  int get totalCandidates => maleCandidates + femaleCandidates;

  factory SchoolExamReport.fromJson(Map<String, dynamic> json) =>
      _$SchoolExamReportFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolExamReportToJson(this);

}