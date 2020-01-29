import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class SchoolsPageData extends Equatable {
  SchoolsPageData({
    @required this.enrolByDistrict,
    @required this.enrolByAuthority,
    @required this.enrolByPrivacy,
    @required this.enrolByAgeAndEducation,
    @required this.enrolBySchoolLevelAndDistrict,
    @required this.filters,
  })  : assert(enrolByDistrict != null),
        assert(enrolByAuthority != null),
        assert(enrolByPrivacy != null),
        assert(enrolByAgeAndEducation != null),
        assert(enrolBySchoolLevelAndDistrict != null),
        assert(filters != null);

  final BuiltMap<String, int> enrolByDistrict;
  final BuiltMap<String, int> enrolByAuthority;
  final BuiltMap<String, int> enrolByPrivacy;
  final BuiltMap<String, BuiltMap<String, InfoTableData>>
      enrolByAgeAndEducation;
  final BuiltMap<String, BuiltMap<String, InfoTableData>>
      enrolBySchoolLevelAndDistrict;
  final BuiltList<Filter> filters;

  @override
  List<Object> get props => [
        enrolByDistrict,
        enrolByAuthority,
        enrolByPrivacy,
        enrolByAgeAndEducation,
        enrolBySchoolLevelAndDistrict,
        filters
      ];
}
