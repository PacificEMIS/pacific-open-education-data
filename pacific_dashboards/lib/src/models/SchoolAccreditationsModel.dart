import 'package:collection/collection.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/ModelWithLookups.dart';
import 'package:pacific_dashboards/src/models/SchoolAccrediatationModel.dart';
import 'package:pacific_dashboards/src/resources/Filter.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';

class SchoolAccreditationsModel extends ModelWithLookups {
  Map<String, Filter> _filters;
  List<SchoolAccreditationModel> accreditations;

  Filter get yearFilter => _filters['year'];

  Filter get stateFilter => _filters['state'];

  Filter get govtFilter => _filters['govt'];

  Filter get authorityFilter => _filters['authority'];

  Filter get schoolLevelFilter => _filters['schoolLevel'];

  SchoolAccreditationsModel.fromJson(List parsedJson) {
    accreditations = List<SchoolAccreditationModel>();
    accreditations =
        parsedJson.map((i) => SchoolAccreditationModel.fromJson(i)).toList();

    _createFilters();
  }

  List toJson() {
    return accreditations.map((i) => (i).toJson()).toList();
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedWithFiltersByState() {
    var filteredList = accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedEvaluated(String year) {
    var filteredList = accreditations
        .where((i) => yearFilter.isEnabledInFilter(year));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByState() {
    return groupBy(
        accreditations, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByStandart() {
    var filteredList = accreditations;
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullStandart(obj.standard));
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFiltersByAuthority() {
    var filteredList = accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList,
        (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByAuthority() {
    return groupBy(accreditations,
        (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedWithFiltersByGovt() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByGovt() {
    return groupBy(
        accreditations, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFilteringBySchoolType() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedBySchoolType() {
    return groupBy(accreditations, (obj) => obj.schoolType);
  }

    Map<dynamic, List<SchoolAccreditationModel>> getSortedByYear() {
    return groupBy(accreditations, (obj) => obj.surveyYear.toString());
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFilteringPerfomanceByStandard() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  List<dynamic> getDistrictCodeKeysList() {
    var statesGroup = groupBy(accreditations, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  void _createFilters() {
    _filters = {
      'year': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].surveyYear.toString()).toSet(),
          AppLocalizations.filterBySelectedYear,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'state': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].districtCode).toSet(),
          AppLocalizations.filterBySelectedState,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'govt': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].authorityGovt).toSet(),
          AppLocalizations.filterBySelectedGovtNonGovt,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'authority': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'authority': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'school level': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'schoolLevel': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySelectedSchoolLevel,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
    };
  }
}
