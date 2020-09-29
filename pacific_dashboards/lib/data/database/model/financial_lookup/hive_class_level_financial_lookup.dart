import 'package:hive/hive.dart';

part 'hive_class_level_financial_lookup.g.dart';

@HiveType(typeId: 17)
class HiveClassLevelFinancialLookup {
  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  @HiveField(2)
  String l;

  @HiveField(3)
  int yearOfEducation;
}
