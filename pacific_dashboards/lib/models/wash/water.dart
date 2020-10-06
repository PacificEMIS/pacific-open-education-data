import 'package:arch/arch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';

part 'water.g.dart';

@JsonSerializable()
class Water implements BaseWash {
  @JsonKey(name: 'schNo') //Year
  final String schNo;
  @override
  @JsonKey(name: "SurveyYear") //DistrictCode
  final int surveyYear;
  @JsonKey(name: 'District', defaultValue: 0) //GNP
  final String district;
  @override
  @JsonKey(name: 'DistrictCode', defaultValue: '')
  final String districtCode;
  @JsonKey(name: 'SchoolType', defaultValue: '')
  final String schoolType;
  @override
  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;
  @JsonKey(name: 'Authority', defaultValue: '')
  final String authority;
  @override
  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovt', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'AuthorityGovtCode', defaultValue: '')
  final String authorityGovtCode;

  @JsonKey(name: 'PipedWaterSupplyCurrentlyAvailable', defaultValue: '')
  final String pipedWaterSupplyCurrentlyAvailable;

  @JsonKey(name: 'PipedWaterSupplyUsedForDrinking', defaultValue: '')
  final String pipedWaterSupplyUsedForDrinking;

  @JsonKey(name: 'ProtectedWellCurrentlyAvailable', defaultValue: '')
  final String protectedWellCurrentlyAvailable;

  @JsonKey(name: 'ProtectedWellUsedForDrinking', defaultValue: '')
  final String protectedWellUsedForDrinking;

  @JsonKey(name: 'UnprotectedWellSpringCurrentlyAvailable', defaultValue: '')
  final String unprotectedWellSpringCurrentlyAvailable;

  @JsonKey(name: 'UnprotectedWellSpringUsedForDrinking', defaultValue: '')
  final String unprotectedWellSpringUsedForDrinking;

  @JsonKey(name: 'RainwaterCurrentlyAvailable', defaultValue: '')
  final String rainwaterCurrentlyAvailable;

  @JsonKey(name: 'RainwaterUsedForDrinking', defaultValue: '')
  final String rainwaterUsedForDrinking;

  @JsonKey(name: 'BottledWaterCurrentlyAvailable', defaultValue: '')
  final String bottledWaterCurrentlyAvailable;

  @JsonKey(name: 'BottledWaterUsedForDrinking', defaultValue: '')
  final String bottledWaterUsedForDrinking;

  @JsonKey(name: 'TankerTruckCartCurrentlyAvailable', defaultValue: '')
  final String tankerTruckCartCurrentlyAvailable;

  @JsonKey(name: 'TankerTruckCartUsedForDrinking', defaultValue: '')
  final String tankerTruckCartUsedForDrinking;

  @JsonKey(name: 'SurfacedWaterCurrentlyAvailable', defaultValue: '')
  final String surfacedWaterCurrentlyAvailable;

  @JsonKey(name: 'SurfacedWaterUsedForDrinking', defaultValue: '')
  final String surfacedWaterUsedForDrinking;

  const Water(
    this.schNo,
    this.surveyYear,
    this.district,
    this.districtCode,
    this.schoolType,
    this.schoolTypeCode,
    this.authority,
    this.authorityCode,
    this.authorityGovt,
    this.authorityGovtCode,
    this.pipedWaterSupplyCurrentlyAvailable,
    this.protectedWellCurrentlyAvailable,
    this.protectedWellUsedForDrinking,
    this.unprotectedWellSpringCurrentlyAvailable,
    this.unprotectedWellSpringUsedForDrinking,
    this.rainwaterCurrentlyAvailable,
    this.rainwaterUsedForDrinking,
    this.bottledWaterCurrentlyAvailable,
    this.bottledWaterUsedForDrinking,
    this.tankerTruckCartCurrentlyAvailable,
    this.tankerTruckCartUsedForDrinking,
    this.surfacedWaterCurrentlyAvailable,
    this.surfacedWaterUsedForDrinking,
    this.pipedWaterSupplyUsedForDrinking,
  );

  factory Water.fromJson(Map<String, dynamic> json) => _$WaterFromJson(json);

  Map<String, dynamic> toJson() => _$WaterToJson(this);
}

extension Filters on List<Water> {
  static const _kYearFilterId = 0;
  static const _kDistrictFilterId = 1;
  static const _kGovtFilterId = 1;
  static const _kAuthorityFilterId = 1;
  static const _kSchoolLevelFilterId = 1;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    return [
      Filter(
        id: _kYearFilterId,
        title: 'filtersByYear',
        items: this
            .uniques((it) => it.surveyYear)
            .chainSort((lv, rv) => rv.compareTo(lv))
            .map((it) => FilterItem(it, it.toString()))
            .toList(),
        selectedIndex: 0,
      ),
    ];
  }

  Future<List<Water>> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      return this.where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
