import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  @JsonKey(name: 'SurveyYear')
  final int surveyYear;

  @JsonKey(name: 'AgeGroup')
  final String ageGroup;

  @JsonKey(name: 'DistrictCode', defaultValue: '')
  final String districtCode;

  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGroupCode', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;

  @JsonKey(name: 'Sector')
  final String sector;

  @JsonKey(name: 'ISCEDSubClass')
  final String iSCEDSubClass;

  @JsonKey(name: 'NumTeachersM', defaultValue: 0)
  final int numTeachersM;

  @JsonKey(name: 'NumTeachersF', defaultValue: 0)
  final int numTeachersF;

  @JsonKey(name: 'CertifiedM', defaultValue: 0)
  final int certifiedM;

  @JsonKey(name: 'CertifiedF', defaultValue: 0)
  final int certifiedF;

  @JsonKey(name: 'QualifiedM', defaultValue: 0)
  final int qualifiedM;

  @JsonKey(name: 'QualifiedF', defaultValue: 0)
  final int qualifiedF;

  @JsonKey(name: 'CertQualM', defaultValue: 0)
  final int certQualM;

  @JsonKey(name: 'CertQualF', defaultValue: 0)
  final int certQualF;

  const Teacher({
    @required this.surveyYear,
    @required this.ageGroup,
    @required this.districtCode,
    @required this.authorityCode,
    @required this.authorityGovt,
    @required this.schoolTypeCode,
    @required this.sector,
    @required this.iSCEDSubClass,
    @required this.numTeachersM,
    @required this.numTeachersF,
    @required this.certifiedM,
    @required this.certifiedF,
    @required this.qualifiedM,
    @required this.qualifiedF,
    @required this.certQualM,
    @required this.certQualF,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  int getTeachersCount(Gender gender) {
    switch (gender) {
      case Gender.male:
        return numTeachersM;
      case Gender.female:
        return numTeachersF;
    }
    throw FallThroughError();
  }

  int get totalTeachersCount {
    return getTeachersCount(Gender.male) + getTeachersCount(Gender.female);
  }
}

extension Filters on List<Teacher> {
  // ignore: unused_field
  static const _kQualifiedFilterId = 0;
  // ignore: unused_field
  static const _kYearFilterId = 1;
  // ignore: unused_field
  static const _kDistrictFilterId = 2;
  // ignore: unused_field
  static const _kAuthorityFilterId = 3;
  // ignore: unused_field
  static const _kGovtFilterId = 4;

  static const _kSchoolLevelFilterId = 5;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    return [
      Filter(
        id: _kQualifiedFilterId,
        title: 'Selected Qualification',
        items: [FilterItem(0, 'Total'),
          FilterItem(1, 'Certified'),
          FilterItem(2, 'Qualified'),
          FilterItem(3, 'Certified and Qualified')],
        selectedIndex: 0,
      ),
      Filter(
        id: _kYearFilterId,
        title: 'filtersByYear',
        items: this
            .uniques((it) => it.surveyYear)
            .where((it) => it != null)
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
              .where((it) => it != null)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
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
              .where((it) => it != null)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: 'filtersByGovernment',
        items: [
          FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
          ...this
              .uniques((it) => it.authorityGovt)
              .where((it) => (it != null && it.isNotEmpty &&  it != "" && it.length > 0))
              .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kSchoolLevelFilterId,
        title: 'filtersBySchoolLevels',
        items: [
          FilterItem(null, 'filtersDisplayAllLevelFilters'),
          ...this
              .uniques((it) => it.schoolTypeCode)
              .map((it) => FilterItem(it, it.from(lookups.schoolTypes))),
        ],
        selectedIndex: 0,
      ),
    ];
  }

  Future<List<Teacher>> applyFilters(List<Filter> filters) {
    return Future(() {
      final qualifeid =  filters.firstWhere((it) => it.id == _kQualifiedFilterId).intValue;
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

      final schoolFilter = filters.firstWhere((it) => it.id == _kSchoolLevelFilterId);

      return this.where((it) {
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

        if (!schoolFilter.isDefault &&
            it.authorityGovt != schoolFilter.stringValue) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}