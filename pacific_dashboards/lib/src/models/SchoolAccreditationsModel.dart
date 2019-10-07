import 'package:collection/collection.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/ModelWithLookups.dart';
import 'package:pacific_dashboards/src/resources/Filter.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';

import 'SchoolAccrediatationModel.dart';

class SchoolAccreditationsModel extends ModelWithLookups {
  Map<String, Filter> _filters;
  List<SchoolAccreditationModel> _accreditations;

  List<SchoolAccreditationModel> get accreditations => _accreditations;

  Filter get yearFilter => _filters['year'];

  Filter get stateFilter => _filters['state'];

  Filter get govtFilter => _filters['govt'];

  Filter get authorityFilter => _filters['authority'];

  Filter get schoolLevelFilter => _filters['schoolLevel'];

  SchoolAccreditationsModel.fromJson(List parsedJson) {
    _accreditations = List<SchoolAccreditationModel>();
    _accreditations =
        parsedJson.map((i) => SchoolAccreditationModel.fromJson(i)).toList();

    _createFilters();
  }

  List toJson() {
    return _accreditations.map((i) => (i).toJson()).toList();
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedWithFiltersByState() {
    var filteredList = _accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedEvaluated(String year) {
    var filteredList = _accreditations
        .where((i) => yearFilter.isEnabledInFilter(year));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByState() {
    return groupBy(
        _accreditations, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByStandart() {
    var filteredList = _accreditations;
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullStandart(obj.standart));
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFiltersByAuthority() {
    var filteredList = _accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList,
        (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByAuthority() {
    return groupBy(_accreditations,
        (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedWithFiltersByGovt() {
    var filteredList = _accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode));
    return groupBy(
        filteredList, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedByGovt() {
    return groupBy(
        _accreditations, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFilteringBySchoolType() {
    var filteredList = _accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  Map<dynamic, List<SchoolAccreditationModel>> getSortedBySchoolType() {
    return groupBy(_accreditations, (obj) => obj.schoolType);
  }

  Map<dynamic, List<SchoolAccreditationModel>>
      getSortedWithFilteringPerfomanceByStandard() {
    var filteredList = _accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  List<dynamic> getDistrictCodeKeysList() {
    var statesGroup = groupBy(_accreditations, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  void _createFilters() {
    _filters = {
      'year': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].surveyYear.toString()).toSet(),
          AppLocalizations.filterBySelectedYear,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'state': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].districtCode).toSet(),
          AppLocalizations.filterBySelectedState,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'govt': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].authorityGovt).toSet(),
          AppLocalizations.filterBySelectedGovtNonGovt,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'authority': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'authority': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'school level': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'schoolLevel': Filter(
          List<String>.generate(_accreditations.length,
              (i) => _accreditations[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySelectedSchoolLevel,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
    };
  }
}
