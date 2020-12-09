import 'package:json_annotation/json_annotation.dart';

part 'school_exam_report.g.dart';

@JsonSerializable()
class SchoolExamReport {
  SchoolExamReport();

  factory SchoolExamReport.fromJson(Map<String, dynamic> json) =>
      _$SchoolExamReportFromJson(json);

  @JsonKey(name: 'examCode')
  String examCode;

  @JsonKey(name: 'examYear')
  int year;

  @JsonKey(name: 'examName', defaultValue: '-')
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

  int get totalCandidates => maleCandidates + femaleCandidates;

  Map<String, dynamic> toJson() => _$SchoolExamReportToJson(this);
}
