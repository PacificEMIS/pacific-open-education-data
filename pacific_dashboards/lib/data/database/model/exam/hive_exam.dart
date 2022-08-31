import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';

import '../../../../models/exam/exam_separated.dart';

part 'hive_exam.g.dart';

@HiveType(typeId: 4)
class HiveExam extends HiveObject with Expirable {
  @HiveField(0)
  String name;

  @HiveField(1)
  int year;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String districtCode;

  @HiveField(4)
  String schoolTypeCode;

  @HiveField(5)
  String authorityCode;

  @HiveField(6)
  String authorityGovtCode;

  @HiveField(7)
  String recordType;

  @HiveField(8)
  String key;

  @HiveField(9)
  String description;

  @HiveField(10)
  int achievementLevel;

  @HiveField(11)
  int candidateCount;

  @HiveField(12)
  int indicatorCount;

  @HiveField(13)
  double weight;


  ExamSeparated toExam() =>
      ExamSeparated(
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
        candidateCount: candidateCount,
        indicatorCount: indicatorCount,
        weight: weight,

      );

  static HiveExam from(ExamSeparated exam) =>
      HiveExam()
        ..name = exam.name
        ..year = exam.year
        ..gender = exam.gender
        ..districtCode = exam.districtCode
        ..schoolTypeCode = exam.schoolTypeCode
        ..authorityCode = exam.authorityCode
        ..authorityGovtCode = exam.authorityGovtCode
        ..recordType = exam.recordType
        ..key = exam.key
        ..description = exam.description
        ..achievementLevel = exam.achievementLevel
        ..candidateCount = exam.candidateCount
        ..indicatorCount = exam.indicatorCount
        ..weight = exam.weight;
}
