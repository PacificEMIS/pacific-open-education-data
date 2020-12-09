import 'package:flutter/material.dart';

class EnrollData {
  const EnrollData({
    @required this.gradeDataOnLastYear,
    @required this.gradeDataHistory,
    @required this.genderDataHistory,
    @required this.femalePartOnLastYear,
    @required this.femalePartHistory,
  });

  final EnrollDataByGradeHistory gradeDataOnLastYear;
  final List<EnrollDataByGradeHistory> gradeDataHistory;
  final List<EnrollDataByYear> genderDataHistory;
  final EnrollDataByFemalePartOnLastYear femalePartOnLastYear;
  final List<EnrollDataByFemalePartHistory> femalePartHistory;
}

class EnrollDataByGrade {
  const EnrollDataByGrade({
    @required this.grade,
    @required this.female,
    @required this.male,
    @required this.total,
  });

  final String grade;
  final int female;
  final int male;
  final int total;
}

class EnrollDataByGradeHistory {
  EnrollDataByGradeHistory({
    @required this.year,
    @required this.data,
  });

  final int year;
  final List<EnrollDataByGrade> data;
}

class EnrollDataByYear {
  const EnrollDataByYear({
    @required this.year,
    @required this.female,
    @required this.male,
    @required this.total,
  });

  final int year;
  final int female;
  final int male;
  final int total;
}

class EnrollDataByFemalePartOnLastYear {
  const EnrollDataByFemalePartOnLastYear({
    @required this.year,
    @required this.data,
  });

  final int year;
  final List<EnrollDataByFemalePart> data;
}

class EnrollDataByFemalePart {
  const EnrollDataByFemalePart({
    @required this.grade,
    @required this.school,
    @required this.district,
    @required this.nation,
  });

  final String grade;
  final int school;
  final int district;
  final int nation;
}

class EnrollDataByFemalePartHistory {
  const EnrollDataByFemalePartHistory({
    @required this.year,
    @required this.school,
    @required this.district,
    @required this.nation,
  });

  final int year;
  final int school;
  final int district;
  final int nation;
}
