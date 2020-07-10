import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class TeachersPageData {
  TeachersPageData({
    @required this.teachersByDistrict,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.teachersBySchoolLevelStateAndGender,
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersBySchoolLevelStateAndGender != null);

  final Map<String, int> teachersByDistrict;
  final Map<String, int> teachersByAuthority;
  final Map<String, int> teachersByPrivacy;
  final Map<String, Map<String, InfoTableData>>
      teachersBySchoolLevelStateAndGender;
}
