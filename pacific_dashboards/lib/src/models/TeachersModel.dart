import "package:collection/collection.dart";
import 'TeacherModel.dart';
import '../resources/Filter.dart';

class TeachersModel {
  List<TeacherModel> _teachers;

  List<TeacherModel> get teachers => _teachers;

  Filter authorityFilter;
  Filter stateFilter;
  Filter schoolTypeFilter;

  TeachersModel.fromJson(List parsedJson) {
    _teachers = List<TeacherModel>();
    _teachers = parsedJson.map((i) => TeacherModel.fromJson(i)).toList();
    _createFilters();
  }

  List toJson() {
    return _teachers.map((i) => (i).toJson()).toList();
  }

  Map<dynamic, List<TeacherModel>> getSortedByState() {
    var filteredList =
        _teachers.where((i) => stateFilter.isEnabledInFilter(i.districtCode));
    var statesGroup = groupBy(filteredList, (obj) => obj.districtCode);
    return statesGroup;
  }

  Map<dynamic, List<TeacherModel>> getSortedByAuthority() {
    var filteredList = _teachers
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode));
    var authorityGroup = groupBy(filteredList, (obj) => obj.authorityCode);
    return authorityGroup;
  }

  Map<dynamic, List<TeacherModel>> getSortedByGovt() {
    var govtGroup = groupBy(_teachers, (obj) => obj.authorityGovt);

    return govtGroup;
  }

  Map<dynamic, List<TeacherModel>> getSortedBySchoolType() {
    var filteredList = _teachers
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));
    var schoolTypeGroup = groupBy(filteredList, (obj) => obj.schoolTypeCode);
    return schoolTypeGroup;
  }

  List<dynamic> getDistrictCodeKeysList() {
    var statesGroup = groupBy(_teachers, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  void _createFilters() {
    authorityFilter = new Filter(
        List<String>.generate(
            _teachers.length, (i) => _teachers[i].authorityCode).toSet(),
        'Schools Enrollment by Authotity');
    stateFilter = new Filter(
        List<String>.generate(
            _teachers.length, (i) => _teachers[i].districtCode).toSet(),
        'Schools Enrollment by State');
    schoolTypeFilter = new Filter(
        List<String>.generate(
            _teachers.length, (i) => _teachers[i].schoolTypeCode).toSet(),
        'Teachers by School type, State and Gender');
  }
}
