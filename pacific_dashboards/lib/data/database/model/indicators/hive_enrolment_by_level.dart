import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';

part 'hive_enrolment_by_level.g.dart';

@HiveType(typeId: 23)
class HiveEnrolmentByLevel extends HiveObject with Expirable {
  @HiveField(0)
  String year;

  @HiveField(1)
  String educationLevelCode;

  @HiveField(2)
  String firstYear;

  @HiveField(3)
  String lastYear;

  @HiveField(4)
  String numYears;

  @HiveField(5)
  String startAge;

  @HiveField(6)
  int populationMale;

  @HiveField(7)
  int populationFemale;

  @HiveField(8)
  int population;

  @HiveField(9)
  int enrolMale;

  @HiveField(10)
  int enrolFemale;

  @HiveField(11)
  int enrol;

  @HiveField(12)
  int enrolOfficialAgeMale;

  @HiveField(13)
  int enrolOfficialAgeFemale;

  @HiveField(14)
  int enrolOfficialAge;

  @HiveField(15)
  int repeatersMale;

  @HiveField(16)
  int repeatersFemale;

  @HiveField(17)
  int repeaters;

  @HiveField(18)
  int netRepeatersMale;

  @HiveField(19)
  int netRepeatersFemale;

  @HiveField(20)
  int netRepeaters;

  @HiveField(21)
  int intakeMale;

  @HiveField(22)
  int intakeFemale;

  @HiveField(23)
  int intake;

  @HiveField(24)
  int netIntakeMale;

  @HiveField(25)
  int netIntakeFemale;

  @HiveField(26)
  int netIntake;

  @HiveField(27)
  double grossEnrolmentRatioMale;

  @HiveField(28)
  double grossEnrolmentRatioFemale;

  @HiveField(29)
  double grossEnrolmentRatio;

  @HiveField(30)
  double netEnrolmentRatioMale;

  @HiveField(31)
  double netEnrolmentRatioFemale;

  @HiveField(32)
  double netEnrolmentRatio;

  @HiveField(33)
  double grossIntakeRatioMale;

  @HiveField(34)
  double grossIntakeRatioFemale;

  @HiveField(35)
  double grossIntakeRatio;

  @HiveField(36)
  double netIntakeRatioMale;

  @HiveField(37)
  double netIntakeRatioFemale;

  @HiveField(38)
  double netIntakeRatio;

  IndicatorsEnrolmentByLevel toIndicatorsEnrolmentByLevel() => IndicatorsEnrolmentByLevel(
    year: year,
    educationLevelCode: educationLevelCode,
    firstYear: firstYear,
    lastYear: lastYear,
    numYears: numYears,
    startAge: startAge,
    populationMale: populationMale,
    populationFemale: populationFemale,
    population: population,
    enrolMale: enrolMale,
    enrolFemale: enrolFemale,
    enrol: enrol,
    enrolOfficialAgeMale: enrolOfficialAgeMale,
    enrolOfficialAgeFemale: enrolOfficialAgeFemale,
    enrolOfficialAge: enrolOfficialAge,
    repeatersMale: repeatersMale,
    repeatersFemale: repeatersFemale,
    repeaters: repeaters,
    netRepeatersMale: netRepeatersMale,
    netRepeatersFemale: netRepeatersFemale,
    netRepeaters: netRepeaters,
    intakeMale: intakeMale,
    intakeFemale: intakeFemale,
    intake: intake,
    netIntakeMale: netIntakeMale,
    netIntakeFemale: netIntakeFemale,
    netIntake: netIntake,
    grossEnrolmentRatioMale: grossEnrolmentRatioMale,
    grossEnrolmentRatioFemale: grossEnrolmentRatioFemale,
    grossEnrolmentRatio: grossEnrolmentRatio,
    netEnrolmentRatioMale: netEnrolmentRatioMale,
    netEnrolmentRatioFemale: netEnrolmentRatioFemale,
    netEnrolmentRatio: netEnrolmentRatio,
    grossIntakeRatioMale: grossIntakeRatioMale,
    grossIntakeRatioFemale: grossIntakeRatioFemale,
    grossIntakeRatio: grossIntakeRatio,
    netIntakeRatioMale: netIntakeRatioMale,
    netIntakeRatioFemale: netIntakeRatioFemale,
    netIntakeRatio: netIntakeRatio,
  );

  static HiveEnrolmentByLevel from(IndicatorsEnrolmentByLevel enrolmentByLevel) => HiveEnrolmentByLevel()
    ..year = enrolmentByLevel.year
    ..educationLevelCode = enrolmentByLevel.educationLevelCode
    ..firstYear = enrolmentByLevel.firstYear
    ..lastYear = enrolmentByLevel.lastYear
    ..numYears = enrolmentByLevel.numYears
    ..startAge = enrolmentByLevel.startAge
    ..populationMale = enrolmentByLevel.populationMale
    ..populationFemale = enrolmentByLevel.populationFemale
    ..population = enrolmentByLevel.population
    ..enrolMale = enrolmentByLevel.enrolMale
    ..enrolFemale = enrolmentByLevel.enrolFemale
    ..enrol = enrolmentByLevel.enrol
    ..enrolOfficialAgeMale = enrolmentByLevel.enrolOfficialAgeMale
    ..enrolOfficialAgeFemale = enrolmentByLevel.enrolOfficialAgeFemale
    ..enrolOfficialAge = enrolmentByLevel.enrolOfficialAge
    ..repeatersMale = enrolmentByLevel.repeatersMale
    ..repeatersFemale = enrolmentByLevel.repeatersFemale
    ..repeaters = enrolmentByLevel.repeaters
    ..netRepeatersMale = enrolmentByLevel.netRepeatersMale
    ..netRepeatersFemale = enrolmentByLevel.netRepeatersFemale
    ..netRepeaters = enrolmentByLevel.netRepeaters
    ..intakeMale = enrolmentByLevel.intakeFemale
    ..intakeFemale = enrolmentByLevel.intakeFemale
    ..intake = enrolmentByLevel.intake
    ..netIntakeMale = enrolmentByLevel.netIntakeMale
    ..netIntakeFemale = enrolmentByLevel.netIntakeFemale
    ..netIntake = enrolmentByLevel.netIntake
    ..grossEnrolmentRatioMale = enrolmentByLevel.grossEnrolmentRatioMale
    ..grossEnrolmentRatioFemale = enrolmentByLevel.grossEnrolmentRatioFemale
    ..grossEnrolmentRatio = enrolmentByLevel.grossIntakeRatio
    ..netEnrolmentRatioMale = enrolmentByLevel.netIntakeRatioMale
    ..netEnrolmentRatioFemale = enrolmentByLevel.netEnrolmentRatioFemale
    ..netEnrolmentRatio = enrolmentByLevel.netEnrolmentRatio
    ..grossIntakeRatioMale = enrolmentByLevel.grossIntakeRatioMale
    ..grossIntakeRatioFemale = enrolmentByLevel.grossIntakeRatioFemale
    ..grossIntakeRatio = enrolmentByLevel.grossIntakeRatio
    ..netIntakeRatioMale = enrolmentByLevel.netIntakeRatioMale
    ..netIntakeRatioFemale = enrolmentByLevel.netIntakeRatioFemale
    ..netIntakeRatio = enrolmentByLevel.netIntakeRatio;
}
