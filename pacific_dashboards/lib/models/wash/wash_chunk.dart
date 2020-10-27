import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/base_wash.dart';
import 'package:pacific_dashboards/models/wash/question.dart';
import 'package:pacific_dashboards/models/wash/toilets.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/models/wash/water.dart';

part 'wash_chunk.g.dart';

typedef FilterApplier<T> = T Function(T a);

@JsonSerializable()
class WashChunk {
  @JsonKey(name: 'total')
  final List<Wash> total;

  @JsonKey(name: 'toilets')
  final List<Toilets> toilets;

  @JsonKey(name: 'water')
  final List<Water> water;

  @JsonKey(name: 'question')
  final List<Question> question;

  const WashChunk({
    @required this.total,
    @required this.toilets,
    @required this.water,
    @required this.question,
  });

  factory WashChunk.fromJson(Map<String, dynamic> json) =>
      _$WashChunkFromJson(json);

  Map<String, dynamic> toJson() => _$WashChunkToJson(this);
}

class WashChunkJsonParts {
  final List<dynamic> total;
  final List<dynamic> toilets;
  final List<dynamic> water;
  final List<dynamic> question;

  const WashChunkJsonParts({this.total, this.toilets, this.water, this.question});
}

extension Filters on WashChunk {
  // ignore: unused_field
  static const _kYearFilterId = 0;

  // ignore: unused_field
  static const _kDistrictFilterId = 1;

  // ignore: unused_field
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
        question: this.question
      );
    });
  }
}
