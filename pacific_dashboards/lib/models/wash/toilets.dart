import 'package:arch/arch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

import 'base_wash.dart';

part 'toilets.g.dart';

@JsonSerializable()
class Toilets implements BaseWash {
  @JsonKey(name: 'schNo') //Year
  final String schNo;
  @override
  @JsonKey(name: "SurveyYear") //DistrictCode
  final int surveyYear;

  @JsonKey(name: 'inspID', defaultValue: 0) //GNP
  final int inspID;

  @JsonKey(name: 'InspectionYear', defaultValue: 0)
  final int inspectionYear;

  @override
  @JsonKey(name: 'DistrictCode', defaultValue: '')
  final String districtCode;
  @override
  @JsonKey(name: 'SchoolTypeCode', defaultValue: '')
  final String schoolTypeCode;
  @override
  @JsonKey(name: 'AuthorityCode', defaultValue: '')
  final String authorityCode;

  @JsonKey(name: 'AuthorityGovt', defaultValue: '')
  final String authorityGovt;

  @JsonKey(name: 'TotalF', defaultValue: 0)
  final int totalF;

  @JsonKey(name: 'UsableF', defaultValue: 0)
  final int usableF;

  @JsonKey(name: 'EnrolF', defaultValue: 0)
  final int enrolF;

  @JsonKey(name: 'TotalC', defaultValue: 0)
  final int totalC;

  @JsonKey(name: 'UsableC', defaultValue: 0)
  final int usableC;

  @JsonKey(name: 'Total', defaultValue: 0)
  final int total;

  @JsonKey(name: 'Usable', defaultValue: 0)
  final int usable;

  @JsonKey(name: 'Enrol', defaultValue: 0)
  final int enrol;

  @JsonKey(name: 'EnrolM', defaultValue: 0)
  final int enrolM;

  @JsonKey(name: 'UsableM', defaultValue: 0)
  final int usableM;

  @JsonKey(name: 'TotalM', defaultValue: 0)
  final int totalM;

  const Toilets(
      this.schNo,
      this.surveyYear,
      this.inspID,
      this.inspectionYear,
      this.districtCode,
      this.schoolTypeCode,
      this.authorityCode,
      this.authorityGovt,
      this.totalF,
      this.usableF,
      this.enrolF,
      this.totalC,
      this.usableC,
      this.total,
      this.usable,
      this.enrol,
      this.enrolM,
      this.usableM,
      this.totalM);

  factory Toilets.fromJson(Map<String, dynamic> json) =>
      _$ToiletsFromJson(json);

  Map<String, dynamic> toJson() => _$ToiletsToJson(this);
}

extension Filters on List<Toilets> {
  static const _kYearFilterId = 0;

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
    ];
  }

  Future<List<Toilets>> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;
      return this.where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }
        return true;
      }).toList();
    });
  }
}
