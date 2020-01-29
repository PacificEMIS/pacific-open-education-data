import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';

part 'hive_exam.g.dart';

@HiveType(typeId: 4)
class HiveExam extends HiveObject with Expirable {
  @HiveField(0)
  String name;

  @HiveField(1)
  int year;

  @HiveField(2)
  String districtCode;

  @HiveField(3)
  String standard;

  @HiveField(4)
  String benchmark;

  @HiveField(5)
  int candidatesM;

  @HiveField(6)
  int wellBelowCompetentM;

  @HiveField(7)
  int approachingCompetenceM;

  @HiveField(8)
  int minimallyCompetentM;

  @HiveField(9)
  int competentM;

  @HiveField(10)
  int candidatesF;

  @HiveField(11)
  int wellBelowCompetentF;

  @HiveField(12)
  int approachingCompetenceF;

  @HiveField(13)
  int minimallyCompetentF;

  @HiveField(14)
  int competentF;

  @override
  @HiveField(15)
  int timestamp;

  Exam toExam() => Exam(
        (b) => b
          ..name = name
          ..year = year
          ..districtCode = districtCode
          ..standard = standard
          ..benchmark = benchmark
          ..candidatesM = candidatesM
          ..wellBelowCompetentM = wellBelowCompetentM
          ..approachingCompetenceM = approachingCompetenceM
          ..minimallyCompetentM = minimallyCompetentM
          ..competentM = competentM
          ..candidatesF = candidatesF
          ..wellBelowCompetentF = wellBelowCompetentF
          ..approachingCompetenceF = approachingCompetenceF
          ..minimallyCompetentF = minimallyCompetentF
          ..competentF = competentF,
      );

  static HiveExam from(Exam exam) => HiveExam()
    ..name = exam.name
    ..year = exam.year
    ..districtCode = exam.districtCode
    ..standard = exam.standard
    ..benchmark = exam.benchmark
    ..candidatesM = exam.candidatesM
    ..wellBelowCompetentM = exam.wellBelowCompetentM
    ..approachingCompetenceM = exam.approachingCompetenceM
    ..minimallyCompetentM = exam.minimallyCompetentM
    ..competentM = exam.competentM
    ..candidatesF = exam.candidatesF
    ..wellBelowCompetentF = exam.wellBelowCompetentF
    ..approachingCompetenceF = exam.approachingCompetenceF
    ..minimallyCompetentF = exam.minimallyCompetentF
    ..competentF = exam.competentF;
}
