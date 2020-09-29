import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/wash/water.dart';

part 'hive_water.g.dart';

@HiveType(typeId: 23)
class HiveWater extends HiveObject with Expirable {
  @HiveField(0)
  String schNo;

  @HiveField(1)
  int surveyYear;

  @HiveField(2)
  String district;

  @HiveField(3)
  String districtCode;

  @HiveField(4)
  String schoolType;

  @HiveField(5)
  String schoolTypeCode;

  @HiveField(6)
  String authority;

  @HiveField(7)
  String authorityCode;

  @HiveField(8)
  String authorityGovt;

  @HiveField(9)
  String authorityGovtCode;

  Water toWater() => Water(
        schNo,
        surveyYear,
        district,
        districtCode,
        schoolType,
        schoolTypeCode,
        authority,
        authorityCode,
        authorityGovt,
        authorityGovtCode,
      );

  static HiveWater from(Water water) => HiveWater()
    ..schNo = water.schNo
    ..surveyYear = water.surveyYear
    ..district = water.district
    ..districtCode = water.districtCode
    ..schoolType = water.schoolType
    ..schoolTypeCode = water.schoolTypeCode
    ..authority = water.authority
    ..authorityCode = water.authorityCode
    ..authorityGovt = water.authorityGovt
    ..authorityGovtCode = water.authorityGovtCode;
}
