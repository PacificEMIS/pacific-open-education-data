import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/lookups/class_level_lookup.dart';

part 'hive_class_level_lookup.g.dart';

@HiveType(typeId: 11)
class HiveClassLevelLookup {
  HiveClassLevelLookup();

  HiveClassLevelLookup.from(ClassLevelLookup lookup)
      : code = lookup.code,
        name = lookup.name,
        l = lookup.l,
        yearOfEducation = lookup.yearOfEducation;

  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  @HiveField(2)
  String l;

  @HiveField(3)
  int yearOfEducation;

  ClassLevelLookup toLookup() => ClassLevelLookup(
        name: name,
        code: code,
        l: l,
        yearOfEducation: yearOfEducation,
      );

  ClassLevelLookup toFinancialLookup() => ClassLevelLookup(
        name: name,
        code: code,
        l: l,
        yearOfEducation: yearOfEducation,
      );
}
