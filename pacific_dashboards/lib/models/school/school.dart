import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'school.g.dart';

@JsonSerializable()
class School {
  @JsonKey(name: 'SchNo', defaultValue: '')
  final String schNo;

  @JsonKey(name: 'SurveyYear', defaultValue: 0)
  final int surveyYear;

  @JsonKey(name: 'ClassLevel', defaultValue: '')
  final String classLevel;

  @JsonKey(name: 'DistrictCode', defaultValue: '')
  final String districtCode;

  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovt', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'Sector', defaultValue: '')
  final String sector;

  @JsonKey(name: 'ISCEDSubClass', defaultValue: '')
  final String iscedSubClass;

  @JsonKey(name: 'NumSupportStaff', defaultValue: 0)
  final int numSupportStaff;

  @JsonKey(name: 'NumTeachers', defaultValue: 0)
  final int numTeachers;

  @JsonKey(name: 'Certified', defaultValue: 0)
  final int certified;

  @JsonKey(name: 'Qualified', defaultValue: 0)
  final int qualified;

  @JsonKey(name: 'CertQual', defaultValue: 0)
  final int certQual;

  @JsonKey(name: 'NumSupportStaffM', defaultValue: 0)
  final int numSupportStaffM;

  @JsonKey(name: 'NumTeachersM', defaultValue: 0)
  final int numTeachersM;

  @JsonKey(name: 'CertifiedM', defaultValue: 0)
  final int certifiedM;

  @JsonKey(name: 'QualifiedM', defaultValue: 0)
  final int qualifiedM;

  @JsonKey(name: 'CertQualM', defaultValue: 0)
  final int certQualM;

  @JsonKey(name: 'NumSupportStaffF', defaultValue: 0)
  final int numSupportStaffF;

  @JsonKey(name: 'NumTeachersF', defaultValue: 0)
  final int numTeachersF;

  @JsonKey(name: 'CertifiedF', defaultValue: 0)
  final int certifiedF;

  @JsonKey(name: 'QualifiedF', defaultValue: 0)
  final int qualifiedF;

  @JsonKey(name: 'CertQualF', defaultValue: 0)
  final int certQualF;

  @JsonKey(name: 'Support', defaultValue: 0)
  final int support;

  @JsonKey(name: 'Age', defaultValue: 0)
  final int age;

  @JsonKey(name: 'GenderCode', defaultValue: '')
  final String genderCode;

  @JsonKey(name: 'EnrolF', defaultValue: 0)
  final int enrolF;

  @JsonKey(name: 'EnrolM', defaultValue: 0)
  final int enrolM;


  const School(
    @required this.iscedSubClass,
    @required this.numSupportStaff,
    @required this.numTeachers,
    @required this.certified,
    @required this.qualified,
    @required this.certQual,
    @required this.numSupportStaffM,
    @required this.numTeachersM,
    @required this.certifiedM,
    @required this.qualifiedM,
    @required this.certQualM,
    @required this.numSupportStaffF,
    @required this.numTeachersF,
    @required this.certifiedF,
    @required this.qualifiedF,
    @required this.certQualF,
    @required this.support,
    @required this.classLevel,
    @required this.schNo,
    @required this.surveyYear,
    @required this.age,
    @required this.districtCode,
    @required this.authorityCode,
    @required this.authorityGovt,
    @required this.genderCode,
    @required this.schoolTypeCode,
    @required this.enrolF,
    @required this.enrolM,
    @required this.sector,
  );

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolToJson(this);

  int get enrol {
     return enrolF + enrolM;
  }

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
      return "no age";
    }

    int ageCoeff = age ~/ 5 + 1;
    return '${((ageCoeff * 5) - 4)}-${(ageCoeff * 5)}';
  }
}

extension Filters on List<School> {
  // ignore: unused_field
  static const _kYearFilterId = 0;
  // ignore: unused_field
  static const _kDistrictFilterId = 1;
  // ignore: unused_field
  static const _kAuthorityFilterId = 3;
  // ignore: unused_field
  static const _kGovtFilterId = 2;
  // ignore: unused_field
  static const _kClassLevelFilterId = 4;

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
          ...this.uniques((it) => it.districtCode).map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: 'filtersByGovernment',
        items: [
          FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
          ...this.uniques((it) => it.authorityGovt).map((it) =>
              FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: 'filtersByAuthority',
        items: [
          FilterItem(null, 'filtersDisplayAllAuthority'),
          ...this.uniques((it) => it.authorityCode).map((it) =>
              FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kClassLevelFilterId,
        title: 'filtersByClassLevel',
        items: [
          FilterItem(null, 'filtersByClassLevel'),
          ...this
              .uniques((it) => it.schoolTypeCode)
              .map((it) => FilterItem(it, it.from(lookups.schoolTypes))),
        ].chainSort((lv, rv) => rv.visibleName.compareTo(lv.visibleName)),
        selectedIndex: 0,
      ),
    ];
  }

  Future<List<School>> applyFilters(List<Filter> filters) {
    return Future(() {
      print(_kYearFilterId);
      if (filters.length == 0) return [];
      final selectedYear = filters.firstWhere((it) => it.id ==
          _kYearFilterId).intValue;

      final districtFilter = filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter = filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

      final classLevelFilter = filters.firstWhere((it) => it.id == _kClassLevelFilterId);

      var sorted = this.where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        if (!districtFilter.isDefault && it.districtCode != districtFilter.stringValue) {
          return false;
        }

        if (!authorityFilter.isDefault && it.authorityCode != authorityFilter.stringValue) {
          return false;
        }

        if (!govtFilter.isDefault && it.authorityGovt != govtFilter.stringValue) {
          return false;
        }

        if (!classLevelFilter.isDefault && it.schoolTypeCode != classLevelFilter.stringValue) {
          return false;
        }

        return true;
      }).toList();
      return sorted;
    });
  }
}
