import "package:collection/collection.dart";
import 'SchoolModel.dart';
import '../resources/Filter.dart';

class SchoolsModel {
  List<SchoolModel> _schools;

  List<SchoolModel> get schools => _schools;

  Filter authorityFilter;
  Filter stateFilter;
  Filter schoolTypeFilter;
  Filter ageFilter;

  SchoolsModel.fromJson(List parsedJson) {
    _schools = List<SchoolModel>();
    _schools = parsedJson.map((i) => SchoolModel.fromJson(i)).toList();

    int ageGroup = 0;
    _schools.forEach((school) => {
          if (school.genderCode == 'M')
            {school.numTeachersM = school.numTeachersM = school.enrol},
          if (school.genderCode == 'F')
            {school.numTeachersF = school.numTeachersF = school.enrol},
          ageGroup = (school.age / 5).ceil(),
          school.ageGroup =
              ((ageGroup * 5) - 4).toString() + '-' + (ageGroup * 5).toString(),
        });

    _createFilters();
  }

  List toJson() {
    return _schools.map((i) => (i).toJson()).toList();
  }

  Map<dynamic, List<SchoolModel>> getSortedByState() {
    var filteredList =
        _schools.where((i) => stateFilter.isEnabledInFilter(i.districtCode));
    var statesGroup = groupBy(filteredList, (obj) => obj.districtCode);
    return statesGroup;
  }

  Map<dynamic, List<SchoolModel>> getSortedByAuthority() {
    var filteredList = _schools
        .where((i) => authorityFilter.isEnabledInFilter(i.authorityCode));
    var authorityGroup = groupBy(filteredList, (obj) => obj.authorityCode);

    return authorityGroup;
  }

  Map<dynamic, List<SchoolModel>> getSortedByGovt() {
    var govtGroup = groupBy(_schools, (obj) => obj.authorityGovt);

    return govtGroup;
  }

  List<dynamic> getDistrictCodeKeysList() {
    var statesGroup = groupBy(_schools, (obj) => obj.districtCode);

    return statesGroup.keys.toList();
  }

  Map<dynamic, List<SchoolModel>> getSortedBySchoolType() {
    var filteredList = _schools
        .where((i) => schoolTypeFilter.isEnabledInFilter(i.schoolTypeCode));
    var schoolTypeGroup = groupBy(filteredList, (obj) => obj.schoolTypeCode);
    return schoolTypeGroup;
  }

  Map<dynamic, List<SchoolModel>> getSortedByAge(int type) {
    var filteredList = _schools
        .where((i) => ageFilter.isEnabledInFilter(i.ageGroup) && i.age > 0);

    switch (type) {
      case 0:
        break;
      case 1:
        filteredList = filteredList.where((i) => ["GK"].contains(i.classLevel));
        break;
      case 2:
        filteredList = filteredList.where((i) => [
          "G1",
          "G2",
          "G3",
          "G4",
          "G5",
          "G6",
          "G7",
          "G8"
        ].contains(i.classLevel));
        break;
      case 3:
        filteredList = filteredList
            .where((i) => ["G9", "G10", "G11", "G12"].contains(i.classLevel));
        break;
      case 4:
        filteredList = filteredList.where((i) => ![
          "GK",
          "G1",
          "G2",
          "G3",
          "G4",
          "G5",
          "G6",
          "G7",
          "G8",
          "G9",
          "G10",
          "G11",
          "G12"
        ].contains(i.classLevel));
        break;
      default:
        break;
    }

    var schoolTypeGroup = groupBy(filteredList, (obj) => obj.ageGroup);
    return schoolTypeGroup;
  }

  void _createFilters() {
    authorityFilter = new Filter(
        List<String>.generate(_schools.length, (i) => _schools[i].authorityCode)
            .toSet(),
        'Schools Enrollment by Authotity');
    stateFilter = new Filter(
        List<String>.generate(_schools.length, (i) => _schools[i].districtCode)
            .toSet(),
        'Schools Enrollment by State');
    schoolTypeFilter = new Filter(
        List<String>.generate(
            _schools.length, (i) => _schools[i].schoolTypeCode).toSet(),
        'Schools Enrollment by School type, State and Gender');
    List<SchoolModel> _schoolsValidAge =
        _schools.where((i) => i.age > 0).toList();
    ageFilter = new Filter(
        List<String>.generate(
                _schoolsValidAge.length, (i) => _schoolsValidAge[i].ageGroup)
            .toSet(),
        'Schools Enrollment by Age');
  }
}
