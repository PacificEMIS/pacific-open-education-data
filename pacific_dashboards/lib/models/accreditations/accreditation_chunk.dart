import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/collections.dart';

part 'accreditation_chunk.g.dart';

typedef FilterApplier<T> = T Function(T a);

abstract class AccreditationChunk
    implements Built<AccreditationChunk, AccreditationChunkBuilder> {
  AccreditationChunk._();

  factory AccreditationChunk([updates(AccreditationChunkBuilder b)]) =
      _$AccreditationChunk;

  @BuiltValueField(wireName: 'byDistrict')
  BuiltList<DistrictAccreditation> get byDistrict;

  @BuiltValueField(wireName: 'byStandard')
  BuiltList<StandardAccreditation> get byStandard;

  String toJson() {
    return json
        .encode(serializers.serializeWith(AccreditationChunk.serializer, this));
  }

  static AccreditationChunk fromJson(String jsonString) {
    return serializers.deserializeWith(
        AccreditationChunk.serializer, json.decode(jsonString));
  }

  static Serializer<AccreditationChunk> get serializer =>
      _$accreditationChunkSerializer;
}

extension Filters on AccreditationChunk {
  // ignore: unused_field
  static const _kYearFilterId = 0;

  // ignore: unused_field
  static const _kDistrictFilterId = 1;

  // ignore: unused_field
  static const _kAuthorityFilterId = 2;

  // ignore: unused_field
  static const _kGovtFilterId = 3;

  BuiltList<Filter> generateDefaultFilters(Lookups lookups) {
    final allItems = (ListBuilder<Accreditation>(this.byDistrict)
          ..addAll(this.byStandard))
        .build();
    return BuiltList.of([
      Filter(
        (b) => b
          ..id = _kYearFilterId
          ..title = AppLocalizations.filterByYear
          ..items = ListBuilder<FilterItem>(
            allItems
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
            ...allItems
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
            ...allItems
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
            ...allItems
                .uniques((it) => it.authorityGovtCode)
                .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
          ])
          ..selectedIndex = 0,
      ),
    ]);
  }

  Future<AccreditationChunk> applyFilters(BuiltList<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

      FilterApplier<Iterable<Accreditation>> apply = (input) {
        return input
          ..where((it) {
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
                it.authorityGovtCode != govtFilter.stringValue) {
              return false;
            }

            return true;
          });
      };

      return this.rebuild((b) => b
        ..byStandard =
            ListBuilder<StandardAccreditation>(apply(this.byStandard))
        ..byDistrict =
            ListBuilder<DistrictAccreditation>(apply(this.byDistrict)));
    });
  }
}
