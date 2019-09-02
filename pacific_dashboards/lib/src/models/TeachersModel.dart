import 'package:collection/collection.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/ModelWithLookups.dart';
import 'package:pacific_dashboards/src/models/TeacherModel.dart';
import 'package:pacific_dashboards/src/resources/Filter.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';

class TeachersModel extends ModelWithLookups {
  Map<String, Filter> _filters;
  List<TeacherModel> _teachers;

  List<TeacherModel> get teachers => _teachers;

  Filter get yearFilter => _filters['year'];

  Filter get stateFilter => _filters['state'];

  Filter get authorityFilter => _filters['authority'];

  Filter get govtFilter => _filters['govt'];

  Filter get schoolTypeFilter => _filters['schoolType'];

  Filter get schoolLevelFilter => _filters['schoolLevel'];

  TeachersModel.fromJson(List parsedJson) {
    _teachers = List<TeacherModel>();
    _teachers = parsedJson.map((i) => TeacherModel.fromJson(i)).toList();
    _createFilters();
  }

  List toJson() {
    return _teachers.map((i) => (i).toJson()).toList();
  }

  Map<dynamic, List<TeacherModel>> getSortedWithFiltersByState() {
    var filteredList = _teachers
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt))
        .where((i) => schoolLevelFilter.isEnabledInFilter(i.iSCEDSubClass))
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));

    return groupBy(
        filteredList, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<TeacherModel>> getSortedByState() {
    return groupBy(
        _teachers, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Map<dynamic, List<TeacherModel>> getSortedWithFiltersByAuthority() {
    var filteredList = _teachers
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt))
        .where((i) => schoolLevelFilter.isEnabledInFilter(i.iSCEDSubClass))
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));

    return groupBy(filteredList,
        (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<TeacherModel>> getSortedByAuthority() {
    return groupBy(
        _teachers, (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<dynamic, List<TeacherModel>> getSortedWithFiltersByGovt() {
    var filteredList = _teachers
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => schoolLevelFilter.isEnabledInFilter(i.iSCEDSubClass))
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));

    return groupBy(
        filteredList, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<TeacherModel>> getSortedByGovt() {
    return groupBy(
        _teachers, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<dynamic, List<TeacherModel>> getSortedWithFilteringBySchoolType() {
    var filteredList = _teachers
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => schoolLevelFilter.isEnabledInFilter(i.iSCEDSubClass))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt));

    return groupBy(filteredList, (obj) => obj.schoolTypeCode);
  }

  Map<dynamic, List<TeacherModel>> getSortedBySchoolType() {
    return groupBy(_teachers, (obj) => obj.schoolTypeCode);
  }

  Map<dynamic, List<TeacherModel>> getSortedWithFilteringBySchoolLevel() {
    var filteredList = _teachers
        .where((i) => stateFilter.isEnabledInFilter(i.districtCode))
        .where((i) => yearFilter.isEnabledInFilter(i.surveyYear.toString()))
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode))
        .where((i) => govtFilter.isEnabledInFilter(i.authorityGovt))
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));

    return groupBy(filteredList, (obj) => obj.iSCEDSubClass);
  }

  Map<dynamic, List<TeacherModel>> getSortedBySchoolLevel() {
    return groupBy(_teachers, (obj) => obj.iSCEDSubClass);
  }

  List<dynamic> getDistrictCodeKeysList() {
    var statesGroup = groupBy(_teachers, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  void _createFilters() {
    _filters = {
      'authority': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].authorityCode).toSet(),
          AppLocalizations.filterByAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'state': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].districtCode).toSet(),
          AppLocalizations.filterByState,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'schoolType': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySchoolType,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'govt': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].authorityGovt).toSet(),
          AppLocalizations.filterByGovernment,
          this,
          LookupsModel.LOOKUPS_KEY_GOVT),
      'year': Filter(
          List<String>.generate(
                  _teachers.length, (i) => _teachers[i].surveyYear.toString())
              .reversed
              .toSet(),
          AppLocalizations.filterByYear,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'schoolLevel': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].iSCEDSubClass).toSet(),
          AppLocalizations.filterByClassLevel,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
    };
    yearFilter.selectMax();
  }
}
