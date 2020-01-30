import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/collections.dart';

part 'teacher.g.dart';

abstract class Teacher implements Built<Teacher, TeacherBuilder> {
  Teacher._();

  factory Teacher([updates(TeacherBuilder b)]) = _$Teacher;

  @BuiltValueField(wireName: 'SurveyYear')
  int get surveyYear;

  @nullable
  @BuiltValueField(wireName: 'AgeGroup')
  String get ageGroup;

  @nullable
  @BuiltValueField(wireName: 'DistrictCode')
  String get districtCodeOptional;

  @nullable
  @BuiltValueField(wireName: 'AuthorityCode')
  String get authorityCodeOptional;

  @nullable
  @BuiltValueField(wireName: 'AuthorityGovt')
  String get authorityGovtOptional;

  @nullable
  @BuiltValueField(wireName: 'SchoolTypeCode')
  String get schoolTypeCodeOptional;

  @nullable
  @BuiltValueField(wireName: 'Sector')
  String get sector;

  @nullable
  @BuiltValueField(wireName: 'ISCEDSubClass')
  String get iSCEDSubClass;

  @nullable
  @BuiltValueField(wireName: 'NumTeachersM')
  int get numTeachersM;

  @nullable
  @BuiltValueField(wireName: 'NumTeachersF')
  int get numTeachersF;

  @nullable
  @BuiltValueField(wireName: 'CertifiedM')
  int get certifiedM;

  @nullable
  @BuiltValueField(wireName: 'CertifiedF')
  int get certifiedF;

  @nullable
  @BuiltValueField(wireName: 'QualifiedM')
  int get qualifiedM;

  @nullable
  @BuiltValueField(wireName: 'QualifiedF')
  int get qualifiedF;

  @nullable
  @BuiltValueField(wireName: 'CertQualM')
  int get certQualM;

  @nullable
  @BuiltValueField(wireName: 'CertQualF')
  int get certQualF;

  String get districtCode => districtCodeOptional ?? "";
  String get authorityCode => authorityCodeOptional ?? "";
  String get authorityGovt => authorityGovtOptional ?? "";
  String get schoolTypeCode => schoolTypeCodeOptional ?? "";

  int getTeachersCount(Gender gender) {
    switch (gender) {
      case Gender.male:
        return numTeachersM ?? 0;
      case Gender.female:
        return numTeachersF ?? 0;
    }
    throw FallThroughError();
  }

  int get totalTeachersCount {
    return getTeachersCount(Gender.male) + getTeachersCount(Gender.female);
  }

  String toJson() {
    return json.encode(serializers.serializeWith(Teacher.serializer, this));
  }

  static Teacher fromJson(String jsonString) {
    return serializers.deserializeWith(
        Teacher.serializer, json.decode(jsonString));
  }

  static Serializer<Teacher> get serializer => _$teacherSerializer;
}


extension Filters on BuiltList<Teacher> {
  // ignore: unused_field
  static const _kYearFilterId = 0;
  // ignore: unused_field
  static const _kDistrictFilterId = 1;
  // ignore: unused_field
  static const _kAuthorityFilterId = 2;
  // ignore: unused_field
  static const _kGovtFilterId = 3;

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
    ]);
  }

  Future<BuiltList<Teacher>> applyFilters(BuiltList<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
      filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
      filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

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

        return true;
      }).toBuiltList();
    });
  }
}
