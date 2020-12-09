import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

part 'hive_school_enroll.g.dart';

@HiveType(typeId: 8)
class HiveSchoolEnroll extends HiveObject {
  HiveSchoolEnroll();

  HiveSchoolEnroll.from(SchoolEnroll enroll)
      : year = enroll.year,
        classLevel = enroll.classLevel,
        enrollFemale = enroll.enrollFemale,
        enrollMale = enroll.enrollMale,
        totalEnroll = enroll.totalEnroll;

  @HiveField(0)
  int year;

  @HiveField(1)
  String classLevel;

  @HiveField(2)
  int enrollFemale;

  @HiveField(3)
  int enrollMale;

  @HiveField(4)
  int totalEnroll;

  SchoolEnroll toSchoolEnroll() => SchoolEnroll()
    ..year = year
    ..classLevel = classLevel
    ..enrollFemale = enrollFemale
    ..enrollMale = enrollMale
    ..totalEnroll = totalEnroll;
}
