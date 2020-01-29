import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/utils/collections.dart';

part 'school.g.dart';

abstract class School implements Built<School, SchoolBuilder> {
  School._();

  factory School([updates(SchoolBuilder b)]) = _$School;

  @BuiltValueField(wireName: 'SurveyYear')
  int get surveyYear;

  @BuiltValueField(wireName: 'ClassLevel')
  String get classLevel;

  @nullable
  @BuiltValueField(wireName: 'Age')
  int get age;

  @BuiltValueField(wireName: 'DistrictCode')
  String get districtCode;

  @BuiltValueField(wireName: 'AuthorityCode')
  String get authorityCode;

  @BuiltValueField(wireName: 'AuthorityGovt')
  String get authorityGovt;

  @BuiltValueField(wireName: 'GenderCode')
  String get genderCode;

  @BuiltValueField(wireName: 'SchoolTypeCode')
  String get schoolTypeCode;

  @nullable
  @BuiltValueField(wireName: 'Enrol')
  int get enrol;

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

  String toJson() {
    return json.encode(serializers.serializeWith(School.serializer, this));
  }

  static School fromJson(String jsonString) {
    return serializers.deserializeWith(
        School.serializer, json.decode(jsonString));
  }

  static Serializer<School> get serializer => _$schoolSerializer;
}

extension Filters on BuiltList<School> {
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

  BuiltList<Filter> generateDefaultFilters(Lookups lookups) {
    return BuiltList.of([
      Filter(
        (b) => b
          ..id = _kYearFilterId
          ..title = AppLocalizations.filterByYear
          ..items = ListBuilder<FilterItem>(
            this
                .uniques((it) => it.surveyYear)
                .sort((lv, rv) => rv.compareTo(lv))
                .map((it) => FilterItem(it, it.toString())),
          )
          ..selectedIndex = 0,
      ),
      Filter(
        (b) => b
          ..id = _kDistrictFilterId
          ..title = AppLocalizations.filterByState
          ..items = ListBuilder<FilterItem>([
            FilterItem(null, AppLocalizations.displayAllStates),
            ...this
                .uniques((it) => it.districtCode)
                .map((it) => FilterItem(it, it.from(lookups.districts))),
          ])
          ..selectedIndex = 0,
      ),
      Filter(
            (b) => b
          ..id = _kAuthorityFilterId
          ..title = AppLocalizations.filterByAuthority
          ..items = ListBuilder<FilterItem>([
            FilterItem(null, AppLocalizations.displayAllAuthority),
            ...this
                .uniques((it) => it.authorityCode)
                .map((it) => FilterItem(it, it.from(lookups.authorities))),
          ])
          ..selectedIndex = 0,
      ),
      Filter(
            (b) => b
          ..id = _kGovtFilterId
          ..title = AppLocalizations.filterByGovernment
          ..items = ListBuilder<FilterItem>([
            FilterItem(null, AppLocalizations.displayAllGovernment),
            ...this
                .uniques((it) => it.authorityGovt)
                .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
          ])
          ..selectedIndex = 0,
      ),
      Filter(
            (b) => b
          ..id = _kClassLevelFilterId
          ..title = AppLocalizations.filterByClassLevel
          ..items = ListBuilder<FilterItem>([
            FilterItem(null, AppLocalizations.displayAllLevelFilters),
            ...this
                .uniques((it) => it.classLevel)
                .map((it) => FilterItem(it, it.from(lookups.levels))),
          ])
          ..selectedIndex = 0,
      ),
    ]);
  }

  Future<BuiltList<School>> applyFilters(BuiltList<Filter> filters) {
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

        if (!classLevelFilter.isDefault &&
            it.classLevel != classLevelFilter.stringValue) {
          return false;
        }

        return true;
      }).toBuiltList();
    });
  }
}
