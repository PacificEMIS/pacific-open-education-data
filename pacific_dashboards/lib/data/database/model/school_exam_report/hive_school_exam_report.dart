import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';

part 'hive_school_exam_report.g.dart';

@HiveType(typeId: 12)
class HiveSchoolExamReport extends HiveObject {

  @HiveField(0)
  String examCode;

  @HiveField(1)
  int year;

  @HiveField(2)
  String examName;

  @HiveField(3)
  String benchmarkCode;

  @HiveField(4)
  String benchmarkDescription;

  @HiveField(5)
  int achievementLevel;

  @HiveField(6)
  String achievementDescription;

  @HiveField(7)
  int maleCandidates;

  @HiveField(8)
  int femaleCandidates;

  SchoolExamReport toSchoolExamReport() => SchoolExamReport()
    ..examCode = examCode
    ..year = year
    ..examName = examName
    ..benchmarkCode = benchmarkCode
    ..benchmarkDescription = benchmarkDescription
    ..achievementLevel = achievementLevel
    ..achievementDescription = achievementDescription
    ..maleCandidates = maleCandidates
    ..femaleCandidates = femaleCandidates;

  static HiveSchoolExamReport from(SchoolExamReport report) => HiveSchoolExamReport()
    ..examCode = report.examCode
    ..year = report.year
    ..examName = report.examName
    ..benchmarkCode = report.benchmarkCode
    ..benchmarkDescription = report.benchmarkDescription
    ..achievementLevel = report.achievementLevel
    ..achievementDescription = report.achievementDescription
    ..maleCandidates = report.maleCandidates
    ..femaleCandidates = report.femaleCandidates;
}
