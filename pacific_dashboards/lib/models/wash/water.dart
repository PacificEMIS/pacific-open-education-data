import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';

part 'water.g.dart';

@JsonSerializable()
class Water implements BaseWash {
  const Water({
    @required this.schNo,
    @required this.surveyYear,
    @required this.district,
    @required this.districtCode,
    @required this.schoolType,
    @required this.schoolTypeCode,
    @required this.authority,
    @required this.authorityCode,
    @required this.authorityGovt,
    @required this.authorityGovtCode,
    @required this.pipedWaterSupplyCurrentlyAvailable,
    @required this.pipedWaterSupplyUsedForDrinking,
    @required this.protectedWellCurrentlyAvailable,
    @required this.protectedWellUsedForDrinking,
    @required this.unprotectedWellSpringCurrentlyAvailable,
    @required this.unprotectedWellSpringUsedForDrinking,
    @required this.rainwaterCurrentlyAvailable,
    @required this.rainwaterUsedForDrinking,
    @required this.bottledWaterCurrentlyAvailable,
    @required this.bottledWaterUsedForDrinking,
    @required this.tankerTruckCartCurrentlyAvailable,
    @required this.tankerTruckCartUsedForDrinking,
    @required this.surfacedWaterCurrentlyAvailable,
    @required this.surfacedWaterUsedForDrinking,
  });

  factory Water.fromJson(Map<String, dynamic> json) => _$WaterFromJson(json);

  static const _kBoolTrueAsBackendString = 'Yes';

  @JsonKey(name: 'schNo', defaultValue: '')
  final String schNo;

  @override
  @JsonKey(name: 'SurveyYear')
  final int surveyYear;

  @JsonKey(name: 'District', defaultValue: 0)
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

  bool get isPipedWaterSupplyCurrentlyAvailable =>
      pipedWaterSupplyCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'PipedWaterSupplyUsedForDrinking', defaultValue: '')
  final String pipedWaterSupplyUsedForDrinking;

  bool get isPipedWaterSupplyUsedForDrinking =>
      pipedWaterSupplyUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'ProtectedWellCurrentlyAvailable', defaultValue: '')
  final String protectedWellCurrentlyAvailable;

  bool get isProtectedWellCurrentlyAvailable =>
      protectedWellCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'ProtectedWellUsedForDrinking', defaultValue: '')
  final String protectedWellUsedForDrinking;

  bool get isProtectedWellUsedForDrinking =>
      protectedWellUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'UnprotectedWellSpringCurrentlyAvailable', defaultValue: '')
  final String unprotectedWellSpringCurrentlyAvailable;

  bool get isUnprotectedWellSpringCurrentlyAvailable =>
      unprotectedWellSpringCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'UnprotectedWellSpringUsedForDrinking', defaultValue: '')
  final String unprotectedWellSpringUsedForDrinking;

  bool get isUnprotectedWellSpringUsedForDrinking =>
      unprotectedWellSpringUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'RainwaterCurrentlyAvailable', defaultValue: '')
  final String rainwaterCurrentlyAvailable;

  bool get isRainwaterCurrentlyAvailable =>
      rainwaterCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'RainwaterUsedForDrinking', defaultValue: '')
  final String rainwaterUsedForDrinking;

  bool get isRainwaterUsedForDrinking =>
      rainwaterUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'BottledWaterCurrentlyAvailable', defaultValue: '')
  final String bottledWaterCurrentlyAvailable;

  bool get isBottledWaterCurrentlyAvailable =>
      bottledWaterCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'BottledWaterUsedForDrinking', defaultValue: '')
  final String bottledWaterUsedForDrinking;

  bool get isBottledWaterUsedForDrinking =>
      bottledWaterUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'TankerTruckCartCurrentlyAvailable', defaultValue: '')
  final String tankerTruckCartCurrentlyAvailable;

  bool get isTankerTruckCartCurrentlyAvailable =>
      tankerTruckCartCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'TankerTruckCartUsedForDrinking', defaultValue: '')
  final String tankerTruckCartUsedForDrinking;

  bool get isTankerTruckCartUsedForDrinking =>
      tankerTruckCartUsedForDrinking == _kBoolTrueAsBackendString;

  @JsonKey(name: 'SurfacedWaterCurrentlyAvailable', defaultValue: '')
  final String surfacedWaterCurrentlyAvailable;

  bool get isSurfacedWaterCurrentlyAvailable =>
      surfacedWaterCurrentlyAvailable == _kBoolTrueAsBackendString;

  @JsonKey(name: 'SurfacedWaterUsedForDrinking', defaultValue: '')
  final String surfacedWaterUsedForDrinking;

  bool get isSurfacedWaterUsedForDrinking =>
      surfacedWaterUsedForDrinking == _kBoolTrueAsBackendString;

  Map<String, dynamic> toJson() => _$WaterToJson(this);
}

extension Filters on List<Water> {
  static const _kYearFilterId = 0;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    return [
      Filter(
        id: _kYearFilterId,
        title: 'filtersByYear',
        items: uniques((it) => it.surveyYear)
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

      return where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
