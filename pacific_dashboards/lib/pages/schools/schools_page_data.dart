import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class SchoolsPageData extends Equatable {
  SchoolsPageData({
    @required this.schools,
    @required this.enrolByDistrict,
    @required this.enrolByAuthority,
    @required this.enrolByPrivacy,
    @required this.enrolByAgeAndEducation,
    @required this.enrolBySchoolLevelAndDistrict,
  })  : assert(schools != null),
        assert(enrolByDistrict != null),
        assert(enrolByAuthority != null),
        assert(enrolByPrivacy != null),
        assert(enrolByAgeAndEducation != null),
        assert(enrolBySchoolLevelAndDistrict != null);

  final BuiltList schools;
  final BuiltMap<String, int> enrolByDistrict;
  final BuiltMap<String, int> enrolByAuthority;
  final BuiltMap<String, int> enrolByPrivacy;
  final BuiltMap<String, BuiltMap<String, InfoTableData>>
      enrolByAgeAndEducation;
  final BuiltMap<String, BuiltMap<String, InfoTableData>>
      enrolBySchoolLevelAndDistrict;

  @override
  List<Object> get props => [
        schools,
        enrolByDistrict,
        enrolByAuthority,
        enrolByPrivacy,
        enrolByAgeAndEducation,
        enrolBySchoolLevelAndDistrict,
      ];
}
