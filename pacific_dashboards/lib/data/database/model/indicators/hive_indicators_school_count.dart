import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/indicators/indicators_school_count.dart';

part 'hive_indicators_school_count.g.dart';

@HiveType(typeId: 24)
class HiveIndicatorsSchoolCount extends HiveObject with Expirable {
  @HiveField(0)
  String year;

  @HiveField(1)
  String schoolType;

  @HiveField(2)
  int count;

  IndicatorsSchoolCount toIndicatorsSchoolCount() => IndicatorsSchoolCount(
    year: year,
    schoolType: schoolType,
    count: count,
  );

  static HiveIndicatorsSchoolCount from(IndicatorsSchoolCount indicatorsSchoolCount) => HiveIndicatorsSchoolCount()
    ..year = indicatorsSchoolCount.year
    ..schoolType = indicatorsSchoolCount.schoolType
    ..count = indicatorsSchoolCount.count;
}
