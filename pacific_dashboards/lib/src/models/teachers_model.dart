import "package:collection/collection.dart";

import 'teacher_model.dart';

class TeachersModel {
  List<TeacherModel> _teachers;

  List<TeacherModel> get teachers => _teachers;

  TeachersModel.fromJson(List<dynamic> parsedJson) {
    _teachers = new List<TeacherModel>();
    _teachers = parsedJson.map((i) => TeacherModel.fromJson(i)).toList();
  }

  Map<dynamic, List<TeacherModel>> getEnrollmentByState() {
    var statesGroup = groupBy(_teachers, (obj) => obj.districtCode);
    print(statesGroup.containsKey("CHK"));
    print(statesGroup.containsKey("PNI"));

    return statesGroup;
  }

  Map<dynamic, List<TeacherModel>> getEnrollmentByAuthority() {
    var statesGroup = groupBy(_teachers, (obj) => obj.authorityCode);
    print(statesGroup.containsKey("PDE"));
    print(statesGroup.containsKey("CDE"));

    return statesGroup;
  }

  Map<dynamic, List<TeacherModel>> getEnrollmentByGovt() {
    var statesGroup = groupBy(_teachers, (obj) => obj.authorityGovt);
    print(statesGroup.containsKey("G"));
    print(statesGroup.containsKey("N"));

    return statesGroup;
  }
}
