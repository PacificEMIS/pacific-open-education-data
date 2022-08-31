import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';

import '../../../../models/indicators/indicators_sector_by_level.dart';

part 'hive_sector_by_level.g.dart';

@HiveType(typeId: 27)
class HiveSectorByLevel extends HiveObject with Expirable {
  @HiveField(0)
  String year;

  @HiveField(1)
  String sectorCode;

  @HiveField(2)
  int teachersMale;

  @HiveField(3)
  int teachersFemale;

  @HiveField(4)
  int teachers;

  @HiveField(5)
  int certifiedMale;

  @HiveField(6)
  int certifiedFemale;

  @HiveField(7)
  int certified;

  @HiveField(8)
  int qualifiedMale;

  @HiveField(9)
  int qualifiedFemale;

  @HiveField(10)
  int qualified;

  @HiveField(11)
  int certQualMale;

  @HiveField(12)
  int certQualFemale;

  @HiveField(13)
  int certQual;

  @HiveField(14)
  int enrolmentMale;

  @HiveField(15)
  int enrolmentFemale;

  @HiveField(16)
  int enrolment;

  @HiveField(17)
  double certifiedPercentMale;

  @HiveField(18)
  double certifiedPercentFemale;

  @HiveField(19)
  double certifiedPercent;

  @HiveField(20)
  double qualifiedPercentMale;

  @HiveField(21)
  double qualifiedPercentFemale;

  @HiveField(22)
  double qualifiedPercent;

  @HiveField(23)
  double certQualPercentMale;

  @HiveField(24)
  double certQualPercentFemale;

  @HiveField(25)
  double certQualPercent;

  @HiveField(26)
  double pupilTeacherRatio;

  @HiveField(27)
  double pupilTeacherRatioCertified;

  @HiveField(28)
  double pupilTeacherRatioQualified;

  @HiveField(29)
  double pupilTeacherRatioCertQual;

  IndicatorsSectorByLevel toIndicatorsSectorByLevel() => IndicatorsSectorByLevel(
    year: year,
    sectorCode: sectorCode,
    teachersMale: teachersMale,
    teachersFemale: teachersFemale,
    teachers: teachers,
    certifiedMale: certifiedMale,
    certifiedFemale: certifiedFemale,
    certified: certified,
    qualifiedMale: qualifiedMale,
    qualifiedFemale: qualifiedFemale,
    qualified: qualified,
    certQualMale: certQualMale,
    certQualFemale: certQualFemale,
    certQual: certQual,
    enrolmentMale: enrolmentMale,
    enrolmentFemale: enrolmentFemale,
    enrolment: enrolment,
    certifiedPercentMale: certifiedPercentMale,
    certifiedPercentFemale: certifiedPercentFemale,
    certifiedPercent: certifiedPercent,
    qualifiedPercentMale: qualifiedPercentMale,
    qualifiedPercentFemale: qualifiedPercentFemale,
    qualifiedPercent: qualifiedPercent,
    certQualPercentMale: certQualPercentMale,
    certQualPercentFemale: certQualPercentFemale,
    certQualPercent: certQualPercent,
    pupilTeacherRatio: pupilTeacherRatio,
    pupilTeacherRatioCertified: pupilTeacherRatioCertified,
    pupilTeacherRatioQualified: pupilTeacherRatioQualified,
    pupilTeacherRatioCertQual: pupilTeacherRatioCertQual
  );

  static HiveSectorByLevel from(IndicatorsSectorByLevel sectorByLevel) => HiveSectorByLevel()
    ..year = sectorByLevel.year
    ..sectorCode = sectorByLevel.sectorCode
    ..teachersMale = sectorByLevel.teachersMale
    ..teachersFemale = sectorByLevel.teachersFemale
    ..teachers = sectorByLevel.teachers
    ..certifiedMale = sectorByLevel.certifiedMale
    ..certifiedFemale = sectorByLevel.certifiedFemale
    ..certified = sectorByLevel.certified
    ..qualifiedMale = sectorByLevel.qualifiedMale
    ..qualifiedFemale = sectorByLevel.qualifiedFemale
    ..qualified = sectorByLevel.qualified
    ..certQualMale = sectorByLevel.certQualMale
    ..certQualFemale = sectorByLevel.certQualFemale
    ..certQual = sectorByLevel.certQual
    ..enrolmentMale = sectorByLevel.enrolmentMale
    ..enrolmentFemale = sectorByLevel.enrolmentFemale
    ..enrolment = sectorByLevel.enrolment
    ..certifiedPercentMale = sectorByLevel.certifiedPercentMale
    ..certifiedPercentFemale = sectorByLevel.certifiedPercentFemale
    ..certifiedPercent = sectorByLevel.certifiedPercent
    ..qualifiedPercentMale = sectorByLevel.qualifiedPercentMale
    ..qualifiedPercentFemale = sectorByLevel.qualifiedPercentFemale
    ..qualifiedPercent = sectorByLevel.qualifiedPercent
    ..certQualPercentMale = sectorByLevel.certQualPercentMale
    ..certQualPercentFemale = sectorByLevel.certQualPercentFemale
    ..certQualPercent = sectorByLevel.certQualPercent
    ..pupilTeacherRatio = sectorByLevel.pupilTeacherRatio
    ..pupilTeacherRatioCertified = sectorByLevel.pupilTeacherRatioCertified
    ..pupilTeacherRatioQualified = sectorByLevel.pupilTeacherRatioQualified
    ..pupilTeacherRatioCertQual = sectorByLevel.pupilTeacherRatioCertQual;
}
