import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/accreditations/national_accreditation.dart';

part 'accreditation_chunk.g.dart';

@JsonSerializable()
class AccreditationChunk {
  const AccreditationChunk({
    @required this.byDistrict,
    @required this.byStandard,
    @required this.byNational,
  });

  factory AccreditationChunk.fromJson(Map<String, dynamic> json) =>
      _$AccreditationChunkFromJson(json);

  @JsonKey(name: 'byDistrict')
  final List<DistrictAccreditation> byDistrict;

  @JsonKey(name: 'byStandard')
  final List<StandardAccreditation> byStandard;

  @JsonKey(name: 'byNation')
  final List<NationalAccreditation> byNational;

  Map<String, dynamic> toJson() => _$AccreditationChunkToJson(this);
}

class AccreditationChunkJsonParts {
  const AccreditationChunkJsonParts({
    this.byDistrictJson,
    this.byStandardJson,
    this.byNationJson,
  });

  final List<dynamic> byDistrictJson;
  final List<dynamic> byStandardJson;
  final List<dynamic> byNationJson;
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

  List<Filter> generateDefaultFilters(Lookups lookups) {
    final allItems = List<Accreditation>.of(byDistrict)..addAll(byStandard);
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
          const FilterItem(null, 'filtersDisplayAllStates'),
          ...allItems
              .uniques((it) => it.districtCode)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: 'filtersByAuthority',
        items: [
          const FilterItem(null, 'filtersDisplayAllAuthority'),
          ...allItems
              .uniques((it) => it.authorityCode)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: 'filtersByGovernment',
        items: [
          const FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
          ...allItems
              .uniques((it) => it.authorityGovtCode)
              .map((it) => FilterItem(it, it.from(lookups.authorityGovt))),
        ],
        selectedIndex: 0,
      ),
    ]);
  }

  Future<AccreditationChunk> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      final govtFilter = filters.firstWhere((it) => it.id == _kGovtFilterId);

      Iterable<Accreditation> apply(Iterable<Accreditation> input) {
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
      }

      return AccreditationChunk(
        byDistrict: apply(byDistrict),
        byStandard: apply(byStandard),
        byNational: apply(byNational),
      );
    });
  }
}
