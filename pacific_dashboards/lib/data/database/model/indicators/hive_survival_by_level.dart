import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';
import 'package:pacific_dashboards/models/indicators/indicators_survival_by_level.dart';

import '../../../../models/indicators/indicators_sector_by_level.dart';
import '../../../../models/indicators/indicators_teacher_by_level.dart';

part 'hive_survival_by_level.g.dart';

@HiveType(typeId: 30)
class HiveSurvivalByLevel extends HiveObject with Expirable {
  @HiveField(0)
  String year;

  @HiveField(1)
  String levelCode;

  @HiveField(2)
  String sectorCode;

  @HiveField(3)
  double survivalRate;

  @HiveField(4)
  double survivalRateM;

  @HiveField(5)
  double survivalRateF;


  IndicatorsSurvivalByLevel toIndicatorsSurvivalByLevel() => IndicatorsSurvivalByLevel(
      year: year,
      levelCode: levelCode,
      yearOfEducation: sectorCode,
      survivalRate: survivalRate,
      survivalRateM: survivalRateM,
      survivalRateF: survivalRateF
  );

  static HiveSurvivalByLevel from(IndicatorsSurvivalByLevel byLevel) => HiveSurvivalByLevel()
    ..year = byLevel.year
    ..levelCode = byLevel.levelCode
    ..sectorCode = byLevel.yearOfEducation
    ..survivalRate = byLevel.survivalRate
    ..survivalRateM = byLevel.survivalRateM
    ..survivalRateF = byLevel.survivalRateF;
}
