import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';
import 'package:pacific_dashboards/models/wash/question.dart';
import 'package:pacific_dashboards/models/wash/toilets.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/models/wash/water.dart';

typedef FilterApplier<T> = T Function(T a);

class WashChunk {
  final List<Wash> total;
  final List<Toilets> toilets;
  final List<Water> water;
  final List<Question> questions;

  const WashChunk({
    @required this.total,
    @required this.toilets,
    @required this.water,
    @required this.questions,
  });
}

extension Filters on WashChunk {
  static const _kYearFilterId = 0;
  static const _kDistrictFilterId = 1;
  static const _kAuthorityFilterId = 2;

  // ignore: unused_field
  static const _kGovtFilterId = 3;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    final allItems = List<BaseWash>.of(this.total)
      ..addAll(this.toilets)
      ..addAll(this.water);
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
    ]);
  }

  Future<WashChunk> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      final authorityFilter =
          filters.firstWhere((it) => it.id == _kAuthorityFilterId);

      FilterApplier<Iterable<BaseWash>> apply = (input) {
        var sorted = input.where((it) {
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

          return true;
        }).toList();
        return sorted;
      };

      return WashChunk(
        total: apply(this.total),
        toilets: apply(this.toilets),
        water: apply(this.water),
        questions: this.questions
      );
    });
  }
}
