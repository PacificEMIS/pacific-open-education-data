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
//
//      final districtFilter =
//          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      return this.where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

//        if (!districtFilter.isDefault &&
//            it.districtCode != districtFilter.stringValue) {
//          return false;
//        }

        return true;
      }).toList();
    });
  }
}
