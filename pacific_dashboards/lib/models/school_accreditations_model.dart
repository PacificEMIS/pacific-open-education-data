import 'package:collection/collection.dart';
import 'package:pacific_dashboards/models/filter.dart';
import 'package:pacific_dashboards/models/model_with_lookups.dart';
import 'package:pacific_dashboards/models/school_accreditation_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';

class SchoolAccreditationsModel extends ModelWithLookups {
  Map<String, Filter> _filters;
  List<SchoolAccreditationModel> accreditations;

  Filter get yearFilter => _filters['year'];

  void updateYearFilter(Filter newFilter) {
    _filters['year'] = newFilter;
  }

  Filter get stateFilter => _filters['state'];

  void updateStateFilter(Filter newFilter) {
    _filters['state'] = newFilter;
  }

  Filter get govtFilter => _filters['govt'];

  void updateGovtFilter(Filter newFilter) {
    _filters['govt'] = newFilter;
  }

  Filter get authorityFilter => _filters['authority'];

  void updateAuthorityFilter(Filter newFilter) {
    _filters['authority'] = newFilter;
  }

  Filter get schoolLevelFilter => _filters['schoolLevel'];

  void updateSchoolLevelFilter(Filter newFilter) {
    _filters['schoolLevel'] = newFilter;
  }

  SchoolAccreditationsModel.fromJson(List parsedJson) {
    accreditations = List<SchoolAccreditationModel>();
    accreditations =
        parsedJson.map((i) => SchoolAccreditationModel.fromJson(i)).toList();

    _createFilters();
  }

  List toJson() {
    return accreditations.map((i) => (i).toJson()).toList();
  }

  Map<String, List<SchoolAccreditationModel>> getSortedWithFiltersByState() {
    var filteredList = accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(
        filteredList, (obj) => obj.districtCode);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedEvaluated(String year) {
    var filteredList =
        accreditations.where((i) => yearFilter.isEnabledInFilter(year));
    return groupBy(
        filteredList, (obj) => obj.districtCode);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedByState() {
    return groupBy(
        accreditations, (obj) => obj.districtCode);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedByStandart() {
    var filteredList = accreditations;
    return groupBy(
        filteredList, (obj) => obj.standard);
  }

  Map<String, List<SchoolAccreditationModel>>
      getSortedWithFiltersByAuthority() {
    var filteredList = accreditations
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList,
        (obj) => obj.authorityCode);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedByAuthority() {
    return groupBy(accreditations,
        (obj) => obj.authorityCode);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedWithFiltersByGovt() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode));
    return groupBy(
        filteredList, (obj) => obj.authorityGovt);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedByGovt() {
    return groupBy(
        accreditations, (obj) => obj.authorityGovt);
  }

  Map<String, List<SchoolAccreditationModel>>
      getSortedWithFilteringBySchoolType() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedBySchoolType() {
    return groupBy(accreditations, (obj) => obj.schoolType);
  }

  Map<String, List<SchoolAccreditationModel>> getSortedByYear() {
    return groupBy(accreditations, (obj) => obj.surveyYear.toString());
  }

  Map<String, List<SchoolAccreditationModel>>
      getSortedWithFilteringPerfomanceByStandard() {
    var filteredList = accreditations
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));
    return groupBy(filteredList, (obj) => obj.schoolType);
  }

  List<String> getDistrictCodeKeysList() {
    var statesGroup = groupBy(accreditations, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  void _createFilters() {
    _filters = {
      'year': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].surveyYear.toString()).toSet(),
          AppLocalizations.filterBySelectedYear,
          this),
      'state': Filter(
          List<String>.generate(
                  accreditations.length, (i) => accreditations[i].districtCode)
              .toSet(),
          AppLocalizations.filterBySelectedState,
          this),
      'govt': Filter(
          List<String>.generate(
                  accreditations.length, (i) => accreditations[i].authorityGovt)
              .toSet(),
          AppLocalizations.filterBySelectedGovtNonGovt,
          this),
      'authority': Filter(
          List<String>.generate(
                  accreditations.length, (i) => accreditations[i].authorityCode)
              .toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this),
      'authority': Filter(
          List<String>.generate(
                  accreditations.length, (i) => accreditations[i].authorityCode)
              .toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this),
      'school level': Filter(
          List<String>.generate(
                  accreditations.length, (i) => accreditations[i].authorityCode)
              .toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this),
      'schoolLevel': Filter(
          List<String>.generate(accreditations.length,
              (i) => accreditations[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySelectedSchoolLevels,
          this),
    };
  }
}
