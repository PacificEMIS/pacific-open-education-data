import "package:collection/collection.dart";

import 'school_model.dart';

class SchoolsModel {
  List<SchoolModel> _schools;

  List<SchoolModel> get schools => _schools;

  SchoolsModel.fromJson(List<dynamic> parsedJson) {
    _schools = List<SchoolModel>();
    _schools = parsedJson.map((i) => SchoolModel.fromJson(i)).toList();
  }

  Map<dynamic, List<SchoolModel>> getEnrollmentByState() {
    var statesGroup = groupBy(_schools, (obj) => obj.districtCode);

    return statesGroup;
  }

  Map<dynamic, List<SchoolModel>> getEnrollmentByAuthority() {
    var authorityGroup = groupBy(_schools, (obj) => obj.authorityCode);

    return authorityGroup;
  }

  Map<dynamic, List<SchoolModel>> getEnrollmentByGovt() {
    var govtGroup = groupBy(_schools, (obj) => obj.authorityGovt);

    return govtGroup;
  }
}