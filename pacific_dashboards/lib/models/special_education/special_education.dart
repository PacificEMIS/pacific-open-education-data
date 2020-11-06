import 'package:arch/arch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'special_education.g.dart';

@JsonSerializable()
class SpecialEducation {
  @JsonKey(name: 'SurveyYear') //Year
  final int surveyYear;

  @JsonKey(name: "EdLevelCode") //DistrictCode
  final String edLevelCode;

  @JsonKey(name: 'EdLevel', defaultValue: '') //GNP
  final String edLevel;

  @JsonKey(name: 'EthnicityCode', defaultValue: '')
  final String ethnicityCode;

  @JsonKey(name: 'GenderCode', defaultValue: '')
  final String genderCode;

  @JsonKey(name: 'Gender', defaultValue: '')
  final String gender;

  @JsonKey(name: 'Age', defaultValue: 0)
  final int age;

  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'Authority', defaultValue: '')
  final String authority;

  @JsonKey(name: 'DistrictCode', defaultValue: 0)
  final String districtCode;

  @JsonKey(name: 'District', defaultValue: '') //Ed Expense A
  final String district;

  @JsonKey(name: 'AuthorityGovtCode', defaultValue: '') //Ed Expense B
  final String authorityGovtCode;

  @JsonKey(name: 'AuthorityGovt', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'SсhoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'SchoolType', defaultValue: '')
  final String schoolType;

  @JsonKey(name: 'RegionCode', defaultValue: '')
  final String regionCode;

  @JsonKey(name: 'Region', defaultValue: '')
  final String region;

  @JsonKey(name: 'Num', defaultValue: 0)
  final int number;

  @JsonKey(name: 'Disability', defaultValue: '')
  final String disability;

  @JsonKey(name: 'Environment', defaultValue: '')
  final String environment;

  @JsonKey(name: 'EnglishLearner', defaultValue: '')
  final String englishLearner;

  const SpecialEducation(
      this.surveyYear,
      this.edLevelCode,
      this.edLevel,
      this.ethnicityCode,
      this.genderCode,
      this.gender,
      this.age,
      this.authorityCode,
      this.authority,
      this.districtCode,
      this.district,
      this.authorityGovtCode,
      this.authorityGovt,
      this.schoolTypeCode,
      this.schoolType,
      this.regionCode,
      this.region,
      this.number,
      this.disability,
      this.environment,
      this.englishLearner);

  factory SpecialEducation.fromJson(Map<String, dynamic> json) =>
      _$SpecialEducationFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialEducationToJson(this);
}

extension Filters on List<SpecialEducation> {
  static const _kYearFilterId = 0;
  static const _kDistrictFilterId = 1;
  static const _kGovtFilterId = 2;
  static const _kAuthorityFilterId = 3;
  static const _kSchoolLevelFilterId = 4;

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
      Filter(
        id: _kDistrictFilterId,
        title: 'filtersByState',
        items: [
          FilterItem(null, 'filtersDisplayAllStates'),
          ...this
              .uniques((it) => it.districtCode)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: 'filtersByGovernment',
        items: [
          FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
          ...this
              .uniques((it) => it.authorityGovtCode)
              .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: 'filtersByAuthority',
        items: [
          FilterItem(null, 'filtersDisplayAllAuthority'),
          ...this
              .uniques((it) => it.authorityCode)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kSchoolLevelFilterId,
        title: 'filtersBySchoolLevels',
        items: [
          FilterItem(null, 'filtersDisplayAllLevelFilters'),
          ...this
              .uniques((it) => it.schoolType)
              .map((it) => FilterItem(it, it.from(lookups.levels))),
        ],
        selectedIndex: 0,
      ),
    ];
  }

  Future<List<SpecialEducation>> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final govtFilter =
          filters.firstWhere((it) => it.id == _kGovtFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final schoolLevelFilter =
          filters.firstWhere((it) => it.id == _kSchoolLevelFilterId);

      return this.where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        if (!districtFilter.isDefault &&
            it.districtCode != districtFilter.stringValue) {
          return false;
        }

        if (!govtFilter.isDefault &&
            it.authorityGovtCode != govtFilter.stringValue) {
          return false;
        }
        
        if (!authorityFilter.isDefault &&
            it.authorityCode != authorityFilter.stringValue) {
          return false;
        }

        if (!schoolLevelFilter.isDefault &&
            it.schoolType != schoolLevelFilter.stringValue) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
