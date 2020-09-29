import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/school/school.dart';

part 'hive_school.g.dart';

@HiveType(typeId: 2)
class HiveSchool extends HiveObject with Expirable {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String classLevel;

  @HiveField(2)
  int age;

  @HiveField(3)
  String districtCode;

  @HiveField(4)
  String authorityCode;

  @HiveField(5)
  String authorityGovt;

  @HiveField(6)
  String genderCode;

  @HiveField(7)
  String schoolTypeCode;

  @HiveField(8)
  int enrol;

  @override
  @HiveField(9)
  int timestamp;

  School toSchool() => School(
        surveyYear: surveyYear,
        classLevel: classLevel,
        age: age,
        districtCode: districtCode,
        authorityCode: authorityCode,
        authorityGovt: authorityGovt,
        genderCode: genderCode,
        schoolTypeCode: schoolTypeCode,
        enrol: enrol,
      );

  static HiveSchool from(School school) => HiveSchool()
    ..surveyYear = school.surveyYear
    ..classLevel = school.classLevel
    ..age = school.age
    ..districtCode = school.districtCode
    ..authorityCode = school.authorityCode
    ..authorityGovt = school.authorityGovt
    ..genderCode = school.genderCode
    ..schoolTypeCode = school.schoolTypeCode
    ..enrol = school.enrol;
}
