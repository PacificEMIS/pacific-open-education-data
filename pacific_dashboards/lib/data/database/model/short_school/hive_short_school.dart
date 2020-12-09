import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';

part 'hive_short_school.g.dart';

@HiveType(typeId: 9)
class HiveShortSchool {
  HiveShortSchool();

  HiveShortSchool.from(ShortSchool school)
      : id = school.id,
        name = school.name,
        districtCode = school.districtCode,
        districtName = school.districtName;

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String districtCode;

  @HiveField(3)
  String districtName;

  ShortSchool toShortSchool() => ShortSchool(
        id: id,
        name: name,
        districtCode: districtCode,
        districtName: districtName,
      );
}
