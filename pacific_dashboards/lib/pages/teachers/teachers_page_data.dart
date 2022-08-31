import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

import '../special_education/special_education_data.dart';

class TeachersPageData {
  TeachersPageData({
    @required this.teachersByDistrict,
    @required this.teachersByAuthority,
    @required this.teachersByPrivacy,
    @required this.enrollTeachersBySchoolLevelStateAndGender,
    @required this.teachersByCertification,
  })  : assert(teachersByDistrict != null),
        assert(teachersByAuthority != null),
        assert(teachersByPrivacy != null),
        assert(teachersByCertification != null),
        assert(enrollTeachersBySchoolLevelStateAndGender != null);

  final List<DataByGroup> teachersByDistrict;
  final List<DataByGroup> teachersByAuthority;
  final List<DataByGroup> teachersByPrivacy;

  final EnrollTeachersBySchoolLevelStateAndGender
      enrollTeachersBySchoolLevelStateAndGender;

  final Map<String, TeachersByCertification> teachersByCertification;
}

class EnrollTeachersBySchoolLevelStateAndGender {
  final List<TeachersBySchoolLevelStateAndGender> all;
  final List<TeachersBySchoolLevelStateAndGender> qualified;
  final List<TeachersBySchoolLevelStateAndGender> certified;
  final List<TeachersBySchoolLevelStateAndGender> allQualifiedAndCertified;

  EnrollTeachersBySchoolLevelStateAndGender({
    @required this.all,
    @required this.qualified,
    @required this.certified,
    @required this.allQualifiedAndCertified,
  });
}

class TeachersBySchoolLevelStateAndGender {
  final String state;
  final Map<String, GenderTableData> total;

  TeachersBySchoolLevelStateAndGender({
    @required this.state,
    @required this.total,
  });
}

class TeachersByCertification {
  int certifiedAndQualifiedFemale;
  int qualifiedFemale;
  int certifiedFemale;
  int numberTeachersFemale;

  int certifiedAndQualifiedMale;
  int qualifiedMale;
  int certifiedMale;
  int numberTeachersMale;

  TeachersByCertification({
    @required this.certifiedAndQualifiedFemale,
    @required this.qualifiedFemale,
    @required this.certifiedFemale,
    @required this.numberTeachersFemale,

    @required this.certifiedAndQualifiedMale,
    @required this.qualifiedMale,
    @required this.certifiedMale,
    @required this.numberTeachersMale,
  });
}
