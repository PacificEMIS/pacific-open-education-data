import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/wash/toilets.dart';

part 'hive_toilet.g.dart';

@HiveType(typeId: 21)
class HiveToilet extends HiveObject {
  HiveToilet();

  HiveToilet.from(Toilets toilets)
      : schNo = toilets.schNo,
        surveyYear = toilets.surveyYear,
        districtCode = toilets.districtCode,
        inspID = toilets.inspID,
        inspectionYear = toilets.inspectionYear,
        schoolTypeCode = toilets.schoolTypeCode,
        authorityCode = toilets.authorityCode,
        authorityGovt = toilets.schoolTypeCode,
        totalF = toilets.totalF,
        usableF = toilets.usableF,
        enrolF = toilets.enrolF,
        totalC = toilets.totalC,
        usableC = toilets.usableC,
        total = toilets.total,
        usable = toilets.usable,
        enrol = toilets.enrol,
        enrolM = toilets.enrolM,
        usableM = toilets.usableM,
        totalM = toilets.totalM;

  @HiveField(0)
  String schNo;

  @HiveField(1)
  int surveyYear;

  @HiveField(2)
  int inspID;

  @HiveField(3)
  int inspectionYear;

  @HiveField(4)
  String districtCode;

  @HiveField(5)
  String schoolTypeCode;

  @HiveField(6)
  String authorityCode;

  @HiveField(7)
  String authorityGovt;

  @HiveField(8)
  int totalF;

  @HiveField(9)
  int usableF;

  @HiveField(10)
  int enrolF;

  @HiveField(11)
  int totalC;

  @HiveField(12)
  int usableC;

  @HiveField(13)
  int total;

  @HiveField(14)
  int usable;

  @HiveField(15)
  int enrol;

  @HiveField(16)
  int enrolM;

  @HiveField(17)
  int usableM;

  @HiveField(18)
  int totalM;
  Toilets toToilets() => Toilets(
      schNo,
      surveyYear,
      inspID,
      inspectionYear,
      districtCode,
      schoolTypeCode,
      authorityCode,
      authorityGovt,
      totalF,
      usableF,
      enrolF,
      totalC,
      usableC,
      total,
      usable,
      enrol,
      enrolM,
      usableM,
      totalM);
}
