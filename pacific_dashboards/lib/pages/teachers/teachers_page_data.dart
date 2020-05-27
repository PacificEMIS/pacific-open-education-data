import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class TeachersPageData extends Equatable {
  TeachersPageData({
    @required this.teachersByDistrict,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.teachersBySchoolLevelStateAndGender,
    @required this.filters,
    this.note,
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersBySchoolLevelStateAndGender != null),
        assert(filters != null);

  final Map<String, int> teachersByDistrict;
  final Map<String, int> teachersByAuthority;
  final Map<String, int> teachersByPrivacy;
  final Map<String, Map<String, InfoTableData>>
      teachersBySchoolLevelStateAndGender;
  final List<Filter> filters;
  final String note;

  @override
  List<Object> get props => [
        teachersByDistrict,
        teachersByAuthority,
        teachersByPrivacy,
        teachersBySchoolLevelStateAndGender,
        note,
      ];
}
