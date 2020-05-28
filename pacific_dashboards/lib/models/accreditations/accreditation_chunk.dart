import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/collections.dart';

part 'accreditation_chunk.g.dart';

typedef FilterApplier<T> = T Function(T a);

@JsonSerializable()
class AccreditationChunk {
  @JsonKey(name: 'byDistrict')
  final List<DistrictAccreditation> byDistrict;

  @JsonKey(name: 'byStandard')
  final List<StandardAccreditation> byStandard;

  const AccreditationChunk({
    @required this.byDistrict,
    @required this.byStandard,
  });

  factory AccreditationChunk.fromJson(Map<String, dynamic> json) =>
      _$AccreditationChunkFromJson(json);

  Map<String, dynamic> toJson() => _$AccreditationChunkToJson(this);
}

class AccreditationChunkJsonParts {
  final String byDistrictJsonString;
  final String byStandardJsonString;

  const AccreditationChunkJsonParts({
    this.byDistrictJsonString,
    this.byStandardJsonString,
  });
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
    final allItems = List<Accreditation>.of(this.byDistrict)
      ..addAll(this.byStandard);
    return List.of([
      Filter(
        id: _kYearFilterId,
        title: AppLocalizations.filterByYear,
        items: allItems
            .uniques((it) => it.surveyYear)
            .chainSort((lv, rv) => rv.compareTo(lv))
            .map((it) => FilterItem(it, it.toString()))
            .toList(),
        selectedIndex: 0,
      ),
      Filter(
        id: _kDistrictFilterId,
        title: AppLocalizations.filterByState,
        items: [
          FilterItem(null, AppLocalizations.displayAllStates),
          ...allItems
              .uniques((it) => it.districtCode)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kAuthorityFilterId,
        title: AppLocalizations.filterByAuthority,
        items: [
          FilterItem(null, AppLocalizations.displayAllAuthority),
          ...allItems
              .uniques((it) => it.authorityCode)
              .map((it) => FilterItem(it, it.from(lookups.authorities))),
        ],
        selectedIndex: 0,
      ),
      Filter(
        id: _kGovtFilterId,
        title: AppLocalizations.filterByGovernment,
        items: [
          FilterItem(null, AppLocalizations.displayAllGovernment),
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

      return AccreditationChunk(
        byDistrict: apply(this.byDistrict),
        byStandard: apply(this.byStandard),
      );
    });
  }
}
