import 'package:flutter/material.dart';

class EnrollData {
  final EnrollDataByGradeHistory gradeDataOnLastYear;
  final List<EnrollDataByGradeHistory> gradeDataHistory;
  final List<EnrollDataByYear> genderDataHistory;
  final List<EnrollDataByFemalePart> femalePartOnLastYear;
  final List<EnrollDataByFemalePartHistory> femalePartHistory;

  EnrollData({
    @required this.gradeDataOnLastYear,
    @required this.gradeDataHistory,
    @required this.genderDataHistory,
    @required this.femalePartOnLastYear,
    @required this.femalePartHistory,
  });
}

class EnrollDataByGrade {
  final String grade;
  final int female;
  final int male;
  final int total;

  EnrollDataByGrade({
    @required this.grade,
    @required this.female,
    @required this.male,
    @required this.total,
  });
}

class EnrollDataByGradeHistory {
  final int year;
  final List<EnrollDataByGrade> data;

  EnrollDataByGradeHistory({
    @required this.year,
    @required this.data,
  });
}

class EnrollDataByYear {
  final int year;
  final int female;
  final int male;
  final int total;

  EnrollDataByYear({
    @required this.year,
    @required this.female,
    @required this.male,
    @required this.total,
  });
}

class EnrollDataByFemalePart {
  final String grade;
  final int school;
  final int district;
  final int nation;

  EnrollDataByFemalePart({
    @required this.grade,
    @required this.school,
    @required this.district,
    @required this.nation,
  });
}

class EnrollDataByFemalePartHistory {
  final int year;
  final int school;
  final int district;
  final int nation;

  EnrollDataByFemalePartHistory({
    @required this.year,
    @required this.school,
    @required this.district,
    @required this.nation,
  });
}
