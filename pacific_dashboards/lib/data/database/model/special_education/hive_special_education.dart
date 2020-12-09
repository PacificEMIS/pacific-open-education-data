import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';

part 'hive_special_education.g.dart';

@HiveType(typeId: 18)
class HiveSpecialEducation extends HiveObject {
  HiveSpecialEducation();

  HiveSpecialEducation.from(SpecialEducation specialEducation)
      : surveyYear = specialEducation.surveyYear,
        edLevelCode = specialEducation.edLevelCode,
        edLevel = specialEducation.edLevel,
        ethnicityCode = specialEducation.ethnicityCode,
        genderCode = specialEducation.genderCode,
        gender = specialEducation.gender,
        age = specialEducation.age,
        authorityCode = specialEducation.authorityCode,
        authority = specialEducation.authority,
        districtCode = specialEducation.districtCode,
        district = specialEducation.district,
        authorityGovtCode = specialEducation.authorityGovtCode,
        authorityGovt = specialEducation.authorityGovt,
        schoolTypeCode = specialEducation.schoolTypeCode,
        schoolType = specialEducation.schoolType,
        regionCode = specialEducation.regionCode,
        region = specialEducation.region,
        number = specialEducation.number,
        disability = specialEducation.disability,
        environment = specialEducation.environment,
        englishLearner = specialEducation.englishLearner;

  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String edLevelCode;

  @HiveField(2)
  String edLevel;

  @HiveField(3)
  String ethnicityCode;

  @HiveField(4)
  String genderCode;

  @HiveField(5)
  String gender;

  @HiveField(6)
  int age;

  @HiveField(7)
  String authorityCode;

  @HiveField(8)
  String authority;

  @HiveField(9)
  String districtCode;

  @HiveField(10)
  String district;

  @HiveField(11)
  String authorityGovtCode;

  @HiveField(12)
  String authorityGovt;

  @HiveField(13)
  String schoolTypeCode;

  @HiveField(14)
  String schoolType;

  @HiveField(15)
  String regionCode;

  @HiveField(16)
  String region;

  @HiveField(17)
  int number;

  @HiveField(18)
  String disability;

  @HiveField(19)
  String environment;

  @HiveField(20)
  String englishLearner;

  SpecialEducation toSpecialEducation() => SpecialEducation(
      surveyYear,
      edLevelCode,
      edLevel,
      ethnicityCode,
      genderCode,
      gender,
      age,
      authorityCode,
      authority,
      districtCode,
      district,
      authorityGovtCode,
      authorityGovt,
      schoolTypeCode,
      schoolType,
      regionCode,
      region,
      number,
      disability,
      environment,
      englishLearner);
}
