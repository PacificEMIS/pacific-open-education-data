import 'package:built_collection/built_collection.dart';
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
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersBySchoolLevelStateAndGender != null),
        assert(filters != null);

  final BuiltMap<String, int> teachersByDistrict;
  final BuiltMap<String, int> teachersByAuthority;
  final BuiltMap<String, int> teachersByPrivacy;
  final BuiltMap<String, BuiltMap<String, InfoTableData>>
      teachersBySchoolLevelStateAndGender;
  final BuiltList<Filter> filters;

  @override
  List<Object> get props => [
        teachersByDistrict,
        teachersByAuthority,
        teachersByPrivacy,
        teachersBySchoolLevelStateAndGender,
      ];
}
