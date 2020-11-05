import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

class TeachersPageData {
  TeachersPageData({
    @required this.teachersByDistrict,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.enrollTeachersBySchoolLevelStateAndGender,
    @required this.teachersByCertification,
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersByCertification != null),
        assert(enrollTeachersBySchoolLevelStateAndGender != null);

  final List<ChartData> teachersByDistrict;
  final List<ChartData> teachersByAuthority;
  final List<ChartData> teachersByPrivacy;

  final EnrollTeachersBySchoolLevelStateAndGender enrollTeachersBySchoolLevelStateAndGender;

  final Map<String, Map<String, int>> teachersByCertification;
}

class EnrollTeachersBySchoolLevelStateAndGender {
  final Map<String, Map<String, GenderTableData>> all;
  final Map<String, Map<String, GenderTableData>> qualified;
  final Map<String, Map<String, GenderTableData>> certified;
  final Map<String, Map<String, GenderTableData>> allQualifiedAndCertified;

  EnrollTeachersBySchoolLevelStateAndGender({
    @required this.all,
    @required this.qualified,
    @required this.certified,
    @required this.allQualifiedAndCertified,
  });
}
