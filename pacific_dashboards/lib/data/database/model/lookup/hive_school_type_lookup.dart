import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';
import 'package:pacific_dashboards/models/lookups/school_type_lookup.dart';

part 'hive_school_type_lookup.g.dart';

@HiveType(typeId: 25)
class HiveSchoolTypeLookup {
  @HiveField(0)
  String schoolCode;

  @HiveField(1)
  String level;

  @HiveField(2)
  int yearOfEducation;

  SchoolTypeLookup toLookup() => SchoolTypeLookup(
    schoolCode: schoolCode,
    level: level,
    yearOfEducation: yearOfEducation,
  );

  static HiveSchoolTypeLookup from(SchoolTypeLookup lookup) {
    return HiveSchoolTypeLookup()
      ..schoolCode = lookup.schoolCode
      ..level = lookup.level
      ..yearOfEducation = lookup.yearOfEducation;
  }
}
