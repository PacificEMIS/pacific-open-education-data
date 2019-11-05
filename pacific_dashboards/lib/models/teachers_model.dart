import 'package:collection/collection.dart';
import 'package:pacific_dashboards/models/filter.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/model_with_lookups.dart';
import 'package:pacific_dashboards/models/teacher_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';

class TeachersModel extends ModelWithLookups {
  Map<String, Filter> _filters;
  List<TeacherModel> _teachers;

  List<TeacherModel> get teachers => _teachers;

  Filter get yearFilter => _filters['year'];

  void updateYearFilter(Filter newFilter) {
    _filters['year'] = newFilter;
  }

  Filter get stateFilter => _filters['state'];

  void updateStateFilter(Filter newFilter) {
    _filters['state'] = newFilter;
  }

  Filter get authorityFilter => _filters['authority'];

  void updateAuthorityFilter(Filter newFilter) {
    _filters['authority'] = newFilter;
  }

  Filter get govtFilter => _filters['govt'];

  void updateGovtFilter(Filter newFilter) {
    _filters['govt'] = newFilter;
  }

  Filter get schoolTypeFilter => _filters['schoolType'];

  Filter get schoolLevelFilter => _filters['schoolLevel'];

  void updateSchoolLevelFilter(Filter newFilter) {
    _filters['schoolLevel'] = newFilter;
  }

  TeachersModel.fromJson(List parsedJson) {
    _teachers = List<TeacherModel>();
    _teachers = parsedJson.map((i) => TeacherModel.fromJson(i)).toList();
    _createFilters();
  }

  List toJson() {
    return _teachers.map((i) => (i).toJson()).toList();
  }

  Map<String, List<TeacherModel>> getGroupedByStateWithFilters() {
    return groupBy(
        _filtered, (obj) => lookupsModel.getFullState(obj.districtCode));
  }

  Iterable<TeacherModel> get _filtered => _teachers
      .where((it) => yearFilter.isEnabledInFilter(it.surveyYear.toString()))
      .where((it) => stateFilter.isEnabledInFilter(it.districtCode))
      .where((it) => authorityFilter.isEnabledInFilter(it.authorityCode))
      .where((it) => govtFilter.isEnabledInFilter(it.authorityGovt))
      .where((it) => schoolLevelFilter.isEnabledInFilter(it.iSCEDSubClass))
      .where((it) => schoolTypeFilter.isEnabledInFilter(it.schoolTypeCode));

  Map<String, List<TeacherModel>> getGroupedByAuthorityWithFilters() {
    return groupBy(
        _filtered, (obj) => lookupsModel.getFullAuthority(obj.authorityCode));
  }

  Map<String, List<TeacherModel>> getGroupedByGovtWithFilters() {
    return groupBy(
        _filtered, (obj) => lookupsModel.getFullGovt(obj.authorityGovt));
  }

  Map<String, List<TeacherModel>> getGroupedBySchoolTypeWithFilters() {
    return groupBy(_filtered, (obj) => obj.schoolTypeCode);
  }

  List<String> getDistrictCodeKeys() {
    final Set<String> keySet = {};
    _teachers.forEach((it) => keySet.add(it.districtCode));
    return keySet.toList();
  }

  void _createFilters() {
    _filters = {
      'authority': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].authorityCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_AUTHORITY),
      'state': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].districtCode).toSet(),
          AppLocalizations.filterBySelectedState,
          this,
          LookupsModel.LOOKUPS_KEY_STATE),
      'schoolType': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySelectedAuthority,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'govt': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].authorityGovt).toSet(),
          AppLocalizations.filterBySelectedGovtNonGovt,
          this,
          LookupsModel.LOOKUPS_KEY_GOVT),
      'year': Filter(
          List<String>.generate(
                  _teachers.length, (i) => _teachers[i].surveyYear.toString())
              .reversed
              .toSet(),
          AppLocalizations.filterBySelectedYear,
          this,
          LookupsModel.LOOKUPS_KEY_NO_KEY),
      'schoolLevel': Filter(
          List<String>.generate(
              _teachers.length, (i) => _teachers[i].schoolTypeCode).toSet(),
          AppLocalizations.filterBySelectedSchoolLevels,
          this,
          LookupsModel.LOOKUPS_KEY_SCHOOL_LEVEL),
    };
    yearFilter.selectMax();
  }
}
