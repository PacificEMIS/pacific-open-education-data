import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

part 'hive_teacher.g.dart';

@HiveType(typeId: 3)
class HiveTeacher extends HiveObject with Expirable {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String ageGroup;

  @HiveField(2)
  String districtCode;

  @HiveField(3)
  String authorityCode;

  @HiveField(4)
  String authorityGovt;

  @HiveField(5)
  String schoolTypeCode;

  @HiveField(6)
  String sector;

  @HiveField(7)
  String iSCEDSubClass;

  @HiveField(8)
  int numTeachersM;

  @HiveField(9)
  int numTeachersF;

  @HiveField(10)
  int certifiedM;

  @HiveField(11)
  int certifiedF;

  @HiveField(12)
  int qualifiedM;

  @HiveField(13)
  int qualifiedF;

  @HiveField(14)
  int certQualM;

  @HiveField(15)
  int certQualF;

  @override
  @HiveField(16)
  int timestamp;

  Teacher toTeacher() => Teacher(
        (b) => b
          ..surveyYear = surveyYear
          ..ageGroup = ageGroup
          ..districtCodeOptional = districtCode
          ..authorityCodeOptional = authorityCode
          ..authorityGovtOptional = authorityGovt
          ..schoolTypeCodeOptional = schoolTypeCode
          ..sector = sector
          ..iSCEDSubClass = iSCEDSubClass
          ..numTeachersM = numTeachersM
          ..numTeachersF = numTeachersF
          ..certifiedM = certifiedM
          ..certifiedF = certifiedF
          ..qualifiedM = qualifiedM
          ..qualifiedF = qualifiedF
          ..certQualM = certQualM
          ..certQualF = certQualF,
      );

  static HiveTeacher from(Teacher teacher) => HiveTeacher()
    ..surveyYear = teacher.surveyYear
    ..ageGroup = teacher.ageGroup
    ..districtCode = teacher.districtCode
    ..authorityCode = teacher.authorityCode
    ..authorityGovt = teacher.authorityGovt
    ..schoolTypeCode = teacher.schoolTypeCode
    ..sector = teacher.sector
    ..iSCEDSubClass = teacher.iSCEDSubClass
    ..numTeachersM = teacher.numTeachersM
    ..numTeachersF = teacher.numTeachersF
    ..certifiedM = teacher.certifiedM
    ..certifiedF = teacher.certifiedF
    ..qualifiedM = teacher.qualifiedM
    ..qualifiedF = teacher.qualifiedF
    ..certQualM = teacher.certQualM
    ..certQualF = teacher.certQualF;
}
