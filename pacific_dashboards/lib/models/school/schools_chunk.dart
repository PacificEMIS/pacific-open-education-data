import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';

part 'schools_chunk.g.dart';

typedef FilterApplier<T> = T Function(T a);

@JsonSerializable()
class SchoolsChunk {
  @JsonKey(name: 'byState')
  final List<School> byState;

  @JsonKey(name: 'byAuthority')
  final List<School> byAuthority;

  const SchoolsChunk({
    @required this.byState,
    @required this.byAuthority,
  });

  factory SchoolsChunk.fromJson(Map<String, dynamic> json) =>
      _$SchoolsChunkFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolsChunkToJson(this);
}

class SchoolsChunkJsonParts {
  final List<dynamic> byStateJson;
  final List<dynamic> byAuthorityJson;
  final List<dynamic> byGovtJson;

  const SchoolsChunkJsonParts({
    this.byStateJson,
    this.byAuthorityJson,
    this.byGovtJson,
  });
}

extension Filters on SchoolsChunk {
  // ignore: unused_field
  static const _kYearFilterId = 0;

  // ignore: unused_field
  static const _kDistrictFilterId = 1;

  static const _kGovtFilterId = 2;

  // ignore: unused_field
  static const _kAuthorityFilterId = 3;

  // ignore: unused_field

  // ignore: unused_field
  static const _kClassLevelFilterId = 4;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    final allItems = List<School>.of(this.byState)
      ..addAll(this.byAuthority);
    return List.of([
      Filter(
        id: _kYearFilterId,
        title: 'filtersByYear',
        items: allItems
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
          ...allItems
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
          ...allItems
              .uniques((it) => it.authorityGovt) //TODO replace to GovtCode
              .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: 'filtersByAuthority',
        items: [
          FilterItem(null, 'filtersDisplayAllAuthority'),
          ...allItems
              .uniques((it) => it.authorityCode)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kClassLevelFilterId,
        title: 'filtersByClassLevel',
        items: [
          FilterItem(null, 'filtersByClassLevel'),
          ...allItems
              .uniques((it) => it.schoolTypeCode)
              .map((it) => FilterItem(it, it.from(lookups.schoolTypes))),
        ].chainSort((lv, rv) => rv.visibleName.compareTo(lv.visibleName)),
        selectedIndex: 0,
      ),
    ]);
  }

  Future<SchoolsChunk> applyFilters(
      List<Filter> filters, bool enableYearFilter) {
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

      FilterApplier<Iterable<School>> apply = (input) {
        var sorted = input.where((it) {
          if (it.surveyYear != selectedYear && !enableYearFilter) {
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
              it.authorityGovt != govtFilter.stringValue) { //TODO REplace to govt code
            return false;
          }

          if (!classLevelFilter.isDefault &&
              it.schoolTypeCode != classLevelFilter.stringValue) {
            return false;
          }

          return true;
        }).toList();
        return sorted;
      };

      return SchoolsChunk(
        byState: apply(this.byState),
        byAuthority: apply(this.byAuthority),
      );
    });
  }
}
