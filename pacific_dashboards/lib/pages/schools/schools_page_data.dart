import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/gender_table_widget.dart';

class SchoolsPageData {
  SchoolsPageData({
    @required this.enrolByDistrict,
    @required this.enrolByAuthority,
    @required this.enrolByPrivacy,
    @required this.enrolByAgeAndEducation,
    @required this.enrolBySchoolLevelAndDistrict,
  })  : assert(enrolByDistrict != null),
        assert(enrolByAuthority != null),
        assert(enrolByPrivacy != null),
        assert(enrolByAgeAndEducation != null),
        assert(enrolBySchoolLevelAndDistrict != null);

  final Map<String, int> enrolByDistrict;
  final Map<String, int> enrolByAuthority;
  final Map<String, int> enrolByPrivacy;
  final Map<String, Map<String, GenderTableData>> enrolByAgeAndEducation;
  final Map<String, Map<String, GenderTableData>> enrolBySchoolLevelAndDistrict;
}
