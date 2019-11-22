import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';

class SchoolsPageData extends Equatable {
  SchoolsPageData({
    @required this.rawModel,
    @required this.enrollmentByState,
    @required this.enrollmentByAuthority,
    @required this.enrollmentByPrivacy,
    @required this.enrollmentByAgeAndEducation,
    @required this.enrollmentBySchoolLevelAndState,
  })  : assert(rawModel != null),
        assert(enrollmentByState != null),
        assert(enrollmentByAuthority != null),
        assert(enrollmentByPrivacy != null),
        assert(enrollmentByAgeAndEducation != null),
        assert(enrollmentBySchoolLevelAndState != null);

  final SchoolsModel rawModel;
  final Map<String, int> enrollmentByState;
  final Map<String, int> enrollmentByAuthority;
  final Map<String, int> enrollmentByPrivacy;
  final Map<String, Map<String, InfoTableData>> enrollmentByAgeAndEducation;
  final Map<String, Map<String, InfoTableData>> enrollmentBySchoolLevelAndState;

  @override
  List<Object> get props => [
        rawModel,
        enrollmentByState,
        enrollmentByAuthority,
        enrollmentByPrivacy,
        enrollmentByAgeAndEducation,
        enrollmentBySchoolLevelAndState,
      ];
}
