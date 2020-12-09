import 'package:arch/arch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'budget.g.dart';

@JsonSerializable()
class Budget {
  const Budget(
      this.surveyYear,
      this.districtCode,
      this.gNP,
      this.gNPCapita,
      this.gNPCurrency,
      this.gNPLocal,
      this.gNPCapitaLocal,
      this.govtExpA,
      this.govtExpB,
      this.govtExpBGNPPerc,
      this.edExpA,
      this.edExpB,
      this.edGovtExpBPerc,
      this.edExpAGNPPerc,
      this.edExpBGNPPerc,
      this.edExpAPerHead,
      this.edExpBPerHead,
      this.edExpAPerHeadGNPCapitaPerc,
      this.edExpBPerHeadGNPCapitaPerc,
      this.enrolment,
      this.sectorCode,
      this.edRecurrentExpA,
      this.edRecurrentExpB,
      this.enrolmentNation);

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  @JsonKey(name: 'SurveyYear') //Year
  final int surveyYear;

  @JsonKey(name: 'DistrictCode', defaultValue: '') //DistrictCode
  final String districtCode;

  @JsonKey(name: 'GNP', defaultValue: 0) //GNP
  final double gNP;

  @JsonKey(name: 'GNPCapita', defaultValue: 0)
  final double gNPCapita;

  @JsonKey(name: 'GNPCurrency', defaultValue: 'USD')
  final String gNPCurrency;

  @JsonKey(name: 'GNPLocal', defaultValue: 0)
  final double gNPLocal;

  @JsonKey(name: 'GNPCapitaLocal', defaultValue: 0)
  final double gNPCapitaLocal;

  @JsonKey(name: 'GovtExpA', defaultValue: 0)
  final double govtExpA;

  @JsonKey(name: 'GovtExpB', defaultValue: 0)
  final double govtExpB;

  @JsonKey(name: 'GovtExpBGNPPerc', defaultValue: 0)
  final double govtExpBGNPPerc;

  @JsonKey(name: 'EdExpA', defaultValue: 0) //Ed Expense A
  final double edExpA;

  @JsonKey(name: 'EdExpB', defaultValue: 0) //Ed Expense B
  final double edExpB;

  @JsonKey(name: 'EdGovtExpBPerc', defaultValue: 0)
  final double edGovtExpBPerc;

  @JsonKey(name: 'EdExpAGNPPerc', defaultValue: 0)
  final double edExpAGNPPerc;

  @JsonKey(name: 'EdExpBGNPPerc', defaultValue: 0)
  final double edExpBGNPPerc;

  @JsonKey(name: 'EdExpAPerHead', defaultValue: 0)
  final double edExpAPerHead;

  @JsonKey(name: 'EdExpBPerHead', defaultValue: 0)
  final double edExpBPerHead;

  @JsonKey(name: 'EdExpAPerHeadGNPCapitaPerc', defaultValue: 0)
  final double edExpAPerHeadGNPCapitaPerc;

  @JsonKey(name: 'EdExpBPerHeadGNPCapitaPerc', defaultValue: 0)
  final double edExpBPerHeadGNPCapitaPerc;

  @JsonKey(name: 'Enrolment', defaultValue: 0)
  final double enrolment;

  @JsonKey(name: 'SectorCode', defaultValue: '')
  final String sectorCode;

  @JsonKey(name: 'EdRecurrentExpA', defaultValue: 0)
  final double edRecurrentExpA;

  @JsonKey(name: 'EdRecurrentExpB', defaultValue: 0)
  final double edRecurrentExpB;

  @JsonKey(name: 'EnrolmentNation', defaultValue: 0)
  final int enrolmentNation;

  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}

extension Filters on List<Budget> {
  static const _kYearFilterId = 0;
  static const _kDistrictFilterId = 1;

  List<Filter> generateDefaultFilters(Lookups lookups) {
    return [
      Filter(
        id: _kYearFilterId,
        title: 'filtersByYear',
        items: uniques((it) => it.surveyYear)
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
          ...uniques((it) => it.districtCode)
              .map((it) => FilterItem(it, it.from(lookups.districts))),
        ],
        selectedIndex: 0,
      )
    ];
  }

  Future<List<Budget>> applyFilters(List<Filter> filters) {
    return Future(() {
      final selectedYear =
          filters.firstWhere((it) => it.id == _kYearFilterId).intValue;

      final districtFilter =
          filters.firstWhere((it) => it.id == _kDistrictFilterId);

      return where((it) {
        if (it.surveyYear != selectedYear) {
          return false;
        }

        if (!districtFilter.isDefault &&
            it.districtCode != districtFilter.stringValue) {
          return false;
        }

        return true;
      }).toList();
    });
  }
}
