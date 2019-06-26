import "package:collection/collection.dart";

import 'teacher_model.dart';

class TeachersModel {
  List<TeacherModel> _teachers;

  List<TeacherModel> get teachers => _teachers;

  TeachersModel.fromJson(List parsedJson) {
    _teachers = List<TeacherModel>();
    _teachers = parsedJson.map((i) => TeacherModel.fromJson(i)).toList();
  }

  Map<dynamic, List<TeacherModel>> getSortedByState() {
    var statesGroup = groupBy(_teachers, (obj) => obj.districtCode);

    return statesGroup;
  }

  Map<dynamic, List<TeacherModel>> getSortedByAuthority() {
    var authorityGroup = groupBy(_teachers, (obj) => obj.authorityCode);

    return authorityGroup;
  }

  Map<dynamic, List<TeacherModel>> getSortedByGovt() {
    var govtGroup = groupBy(_teachers, (obj) => obj.authorityGovt);

    return govtGroup;
  }
}
