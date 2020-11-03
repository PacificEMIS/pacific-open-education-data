import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

class TeachersPageData {
  TeachersPageData({
    @required this.teachersByDistrict,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.teachersBySchoolLevelStateAndGender,
    @required this.teachersByCertification,
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersBySchoolLevelStateAndGender != null),
        assert(teachersByCertification != null);

  final List<ChartData> teachersByDistrict;
  final List<ChartData> teachersByAuthority;
  final List<ChartData> teachersByPrivacy;
  final Map<String, Map<String, Map<String, GenderTableData>>>
      teachersBySchoolLevelStateAndGender;
  final Map<String, Map<String, int>> teachersByCertification;
}
