import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class TeachersPageData extends Equatable {
  TeachersPageData({
    @required this.rawModel,
    @required this.teachersByState,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.teachersBySchoolLevelStateAndGender,
  })  : assert(rawModel != null),
        assert(teachersByState != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersBySchoolLevelStateAndGender != null);

  final TeachersModel rawModel;
  final Map<String, int> teachersByState;
  final Map<String, int> teachersByAuthority;
  final Map<String, int> teachersByPrivacy;
  final Map<String, Map<String, InfoTableData>>
      teachersBySchoolLevelStateAndGender;

  @override
  List<Object> get props => [
        rawModel,
        teachersByState,
        teachersByAuthority,
        teachersByPrivacy,
        teachersBySchoolLevelStateAndGender,
      ];
}
