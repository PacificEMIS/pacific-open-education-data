import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';

part 'hive_school_flow.g.dart';

@HiveType(typeId: 10)
class HiveSchoolFlow extends HiveObject {
  HiveSchoolFlow();

  HiveSchoolFlow.from(SchoolFlow flow)
      : year = flow.year,
        yearOfEducation = flow.yearOfEducation,
        repeatRate = flow.repeatRate,
        promoteRate = flow.promoteRate,
        dropoutRate = flow.dropoutRate,
        survivalRate = flow.survivalRate;

  @HiveField(0)
  int year;

  @HiveField(1)
  int yearOfEducation;

  @HiveField(2)
  double repeatRate;

  @HiveField(3)
  double promoteRate;

  @HiveField(4)
  double dropoutRate;

  @HiveField(5)
  double survivalRate;

  SchoolFlow toSchoolFlow() => SchoolFlow()
    ..year = year
    ..yearOfEducation = yearOfEducation
    ..repeatRate = repeatRate
    ..promoteRate = promoteRate
    ..dropoutRate = dropoutRate
    ..survivalRate = survivalRate;
}
