import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

class SchoolsPageData {
  SchoolsPageData({
    @required this.year,
    @required this.enrolByDistrict,
    @required this.enrolByAuthority,
    @required this.enrolByPrivacy,
    @required this.enrolByAgeAndEducation,
    @required this.enrolBySchoolLevelAndDistrict,
    @required this.enrolByEduationLevelAndGender,
  })  : assert(year != null),
        assert(enrolByDistrict != null),
        assert(enrolByAuthority != null),
        assert(enrolByPrivacy != null),
        assert(enrolByAgeAndEducation != null),
        assert(enrolBySchoolLevelAndDistrict != null);

  final String year;
  final List<ChartData> enrolByDistrict;
  final List<ChartData> enrolByAuthority;
  final List<ChartData> enrolByPrivacy;
  final Map<String, Map<String, GenderTableData>> enrolByAgeAndEducation;
  final Map<String, Map<String, GenderTableData>> enrolBySchoolLevelAndDistrict;
  final Map<String, Map<String, GenderTableData>> enrolByEduationLevelAndGender;
}
