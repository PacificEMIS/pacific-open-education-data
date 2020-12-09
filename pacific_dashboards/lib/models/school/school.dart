import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';

part 'school.g.dart';

@JsonSerializable()
class School {
  const School({
    @required this.surveyYear,
    @required this.classLevel,
    @required this.age,
    @required this.districtCode,
    @required this.authorityCode,
    @required this.authorityGovt,
    @required this.genderCode,
    @required this.schoolTypeCode,
    @required this.enrol,
  });

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

  @JsonKey(name: 'SurveyYear')
  final int surveyYear;

  @JsonKey(name: 'ClassLevel')
  final String classLevel;

  @JsonKey(name: 'Age')
  final int age;

  @JsonKey(name: 'DistrictCode')
  final String districtCode;

  @JsonKey(name: 'AuthorityCode')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovt')
  final String authorityGovt;

  @JsonKey(name: 'GenderCode')
  final String genderCode;

  @JsonKey(name: 'SchoolTypeCode')
  final String schoolTypeCode;

  @JsonKey(name: 'Enrol')
  final int enrol;
  Map<String, dynamic> toJson() => _$SchoolToJson(this);

  Gender get gender {
    switch (genderCode) {
      case 'M':
        return Gender.male;
      default:
        return Gender.female;
    }
  }

  String get ageGroup {
    if (age == null) {
      return 'no age';
    }

    final ageCoeff = age ~/ 5 + 1;
    return '${(ageCoeff * 5) - 4}-${ageCoeff * 5}';
  }
}

extension Filters on List<School> {
  // ignore: unused_field
  static const _kYearFilterId = 0;
  // ignore: unused_field
  static const _kDistrictFilterId = 1;
  // ignore: unused_field
  static const _kAuthorityFilterId = 2;
  // ignore: unused_field
  static const _kGovtFilterId = 3;
  // ignore: unused_field
  static const _kClassLevelFilterId = 4;

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
      Filter(
        id: _kDistrictFilterId,
        title: 'filtersByState',
        items: [
          const FilterItem(null, 'filtersDisplayAllStates'),
          ...uniques((it) => it.districtCode)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: 'filtersByAuthority',
        items: [
          const FilterItem(null, 'filtersDisplayAllAuthority'),
          ...uniques((it) => it.authorityCode)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: 'filtersByGovernment',
        items: [
          const FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
          ...uniques((it) => it.authorityGovt)
              .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kClassLevelFilterId,
        title: 'filtersByClassLevel',
        items: [
          const FilterItem(null, 'filtersDisplayAllLevelFilters'),
          ...uniques((it) => it.classLevel)
              .map((it) => FilterItem(it, it.from(lookups.levels))),
        ],
        selectedIndex: 0,
      ),
    ];
  }

  Future<List<School>> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

      final classLevelFilter =
          filters.firstWhere((it) => it.id == _kClassLevelFilterId);

      return where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        if (!districtFilter.isDefault &&
            it.districtCode != districtFilter.stringValue) {
          return false;
        }

        if (!authorityFilter.isDefault &&
            it.authorityCode != authorityFilter.stringValue) {
          return false;
        }

        if (!govtFilter.isDefault &&
            it.authorityGovt != govtFilter.stringValue) {
          return false;
        }

        if (!classLevelFilter.isDefault &&
            it.classLevel != classLevelFilter.stringValue) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
