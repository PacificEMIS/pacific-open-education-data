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
    this.note,
  })  : assert(enrolByDistrict != null),
        assert(enrolByAuthority != null),
        assert(enrolByPrivacy != null),
        assert(enrolByAgeAndEducation != null),
        assert(enrolBySchoolLevelAndDistrict != null),
        assert(filters != null);

  final Map<String, int> enrolByDistrict;
  final Map<String, int> enrolByAuthority;
  final Map<String, int> enrolByPrivacy;
  final Map<String, Map<String, InfoTableData>>
      enrolByAgeAndEducation;
  final Map<String, Map<String, InfoTableData>>
      enrolBySchoolLevelAndDistrict;
  final List<Filter> filters;
  final String note;

  @override
  List<Object> get props => [
        enrolByDistrict,
        enrolByAuthority,
        enrolByPrivacy,
        enrolByAgeAndEducation,
        enrolBySchoolLevelAndDistrict,
        filters,
        note,
      ];
}
