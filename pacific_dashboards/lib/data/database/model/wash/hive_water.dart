import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/wash/water.dart';

part 'hive_water.g.dart';

@HiveType(typeId: 14)
class HiveWater extends HiveObject {
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

  @HiveField(10)
  String pipedWaterSupplyCurrentlyAvailable;

  @HiveField(11)
  String pipedWaterSupplyUsedForDrinking;

  @HiveField(12)
  String protectedWellCurrentlyAvailable;

  @HiveField(13)
  String protectedWellUsedForDrinking;

  @HiveField(14)
  String unprotectedWellSpringCurrentlyAvailable;

  @HiveField(15)
  String unprotectedWellSpringUsedForDrinking;

  @HiveField(16)
  String rainwaterCurrentlyAvailable;

  @HiveField(17)
  String rainwaterUsedForDrinking;

  @HiveField(18)
  String bottledWaterCurrentlyAvailable;

  @HiveField(19)
  String bottledWaterUsedForDrinking;

  @HiveField(20)
  String tankerTruckCartCurrentlyAvailable;

  @HiveField(21)
  String tankerTruckCartUsedForDrinking;

  @HiveField(22)
  String surfacedWaterCurrentlyAvailable;

  @HiveField(23)
  String surfacedWaterUsedForDrinking;

  Water toWater() => Water(
        schNo: schNo,
        surveyYear: surveyYear,
        district: district,
        districtCode: districtCode,
        schoolType: schoolType,
        schoolTypeCode: schoolTypeCode,
        authority: authority,
        authorityCode: authorityCode,
        authorityGovt: authorityGovt,
        authorityGovtCode: authorityGovtCode,
        pipedWaterSupplyCurrentlyAvailable: pipedWaterSupplyCurrentlyAvailable,
        pipedWaterSupplyUsedForDrinking: pipedWaterSupplyUsedForDrinking,
        protectedWellCurrentlyAvailable: protectedWellCurrentlyAvailable,
        protectedWellUsedForDrinking: protectedWellUsedForDrinking,
        unprotectedWellSpringCurrentlyAvailable: unprotectedWellSpringCurrentlyAvailable,
        unprotectedWellSpringUsedForDrinking: unprotectedWellSpringUsedForDrinking,
        rainwaterCurrentlyAvailable: rainwaterCurrentlyAvailable,
        rainwaterUsedForDrinking: rainwaterUsedForDrinking,
        bottledWaterCurrentlyAvailable: bottledWaterCurrentlyAvailable,
        bottledWaterUsedForDrinking: bottledWaterUsedForDrinking,
        tankerTruckCartCurrentlyAvailable: tankerTruckCartCurrentlyAvailable,
        tankerTruckCartUsedForDrinking: tankerTruckCartUsedForDrinking,
        surfacedWaterCurrentlyAvailable: surfacedWaterCurrentlyAvailable,
        surfacedWaterUsedForDrinking: surfacedWaterUsedForDrinking,
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
    ..authorityGovtCode = water.authorityGovtCode
    ..pipedWaterSupplyCurrentlyAvailable =
        water.pipedWaterSupplyCurrentlyAvailable
    ..pipedWaterSupplyUsedForDrinking = water.pipedWaterSupplyUsedForDrinking
    ..protectedWellCurrentlyAvailable = water.protectedWellCurrentlyAvailable
    ..protectedWellUsedForDrinking = water.protectedWellUsedForDrinking
    ..unprotectedWellSpringCurrentlyAvailable =
        water.unprotectedWellSpringCurrentlyAvailable
    ..unprotectedWellSpringUsedForDrinking =
        water.unprotectedWellSpringUsedForDrinking
    ..rainwaterCurrentlyAvailable = water.rainwaterCurrentlyAvailable
    ..rainwaterUsedForDrinking = water.rainwaterUsedForDrinking
    ..bottledWaterCurrentlyAvailable = water.bottledWaterCurrentlyAvailable
    ..bottledWaterUsedForDrinking = water.bottledWaterUsedForDrinking
    ..tankerTruckCartCurrentlyAvailable =
        water.tankerTruckCartCurrentlyAvailable
    ..tankerTruckCartUsedForDrinking = water.tankerTruckCartUsedForDrinking
    ..surfacedWaterCurrentlyAvailable = water.surfacedWaterCurrentlyAvailable
    ..surfacedWaterUsedForDrinking = water.surfacedWaterUsedForDrinking;
}
