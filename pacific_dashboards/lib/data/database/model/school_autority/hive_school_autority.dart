import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/db_impl/schools_autority_dao_impl.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/school/school.dart';

part 'hive_school_autority.g.dart';

@HiveType(typeId: 26)
class HiveSchoolAutority extends HiveObject with Expirable {
  @HiveField(0)
  String schNo;

  @HiveField(1)
  int surveyYear;

  @HiveField(2)
  String classLevel;

  @HiveField(3)
  String districtCode;

  @HiveField(4)
  String authorityCode;

  @HiveField(5)
  String schoolTypeCode;

  @HiveField(6)
  String sector;

  @HiveField(7)
  String iscedSubClass;

  @HiveField(8)
  int numSupportStaff;

  @override
  @HiveField(9)
  int numTeachers;

  @override
  @HiveField(10)
  int certified;

  @override
  @HiveField(11)
  int qualified;

  @override
  @HiveField(12)
  int certQual;

  @override
  @HiveField(13)
  int numSupportStaffM;

  @override
  @HiveField(14)
  int numTeachersM;

  @override
  @HiveField(15)
  int CertifiedM;

  @override
  @HiveField(16)
  int qualifiedM;

  @override
  @HiveField(17)
  int certQualM;

  @override
  @HiveField(18)
  int numSupportStaffF;

  @override
  @HiveField(19)
  int numTeachersF;

  @override
  @HiveField(20)
  int certifiedF;

  @override
  @HiveField(21)
  int qualifiedF;

  @override
  @HiveField(22)
  int certQualF;

  @override
  @HiveField(23)
  int support;

  @override
  @HiveField(24)
  int age;

  @override
  @HiveField(25)
  String genderCode;

  @override
  @HiveField(26)
  int enrol;

  @override
  @HiveField(27)
  String authorityGovt;

  @override
  @HiveField(28)
  int certifiedM;

  School toSchool() => School(
    iscedSubClass,
    numSupportStaff,
    numTeachers,
    certified,
    qualified,
    certQual,
    numSupportStaffM,
    numTeachersM,
    certifiedM,
    qualifiedM,
    certQualM,
    numSupportStaffF,
    numTeachersF,
    certifiedF,
    qualifiedF,
    certQualF,
    support,
    classLevel,
    schNo,
    surveyYear,
    age,
    districtCode,
    authorityCode,
    authorityGovt,
    genderCode,
    schoolTypeCode,
    enrol,
    sector,
  );

  static HiveSchoolAutority from(School school) => HiveSchoolAutority()
    ..schNo = school.schNo
    ..surveyYear = school.surveyYear
    ..classLevel = school.classLevel
    ..districtCode = school.districtCode
    ..authorityCode = school.authorityCode
    ..authorityGovt = school.authorityGovt
    ..schoolTypeCode = school.schoolTypeCode
    ..sector = school.sector
    ..iscedSubClass = school.iscedSubClass
    ..numSupportStaff = school.numSupportStaff
    ..numTeachers = school.numTeachers
    ..certified = school.certified
    ..qualified = school.qualified
    ..certQual = school.certQual
    ..numSupportStaffM = school.numSupportStaffM
    ..numTeachersM = school.numTeachersM
    ..certifiedM = school.certifiedM
    ..qualifiedM = school.qualifiedM
    ..certQualM = school.certQualM
    ..numSupportStaffF = school.numSupportStaffF
    ..numTeachersF = school.numTeachersF
    ..certifiedF = school.certifiedF
    ..qualifiedF = school.qualifiedF
    ..certQualF = school.certQualF
    ..support = school.support
    ..age = school.age
    ..genderCode = school.genderCode
    ..enrol = school.enrol;
}
