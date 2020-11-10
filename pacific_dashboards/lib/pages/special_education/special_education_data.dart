import 'package:flutter/foundation.dart';

class SpecialEducationData {
  final int year;
  final List<DataByGroup> dataByGender;
  final List<DataByGroup> dataByEthnicity;
  final List<DataByGroup> dataBySpecialEdEnvironment;
  final List<DataByGroup> dataByEnglishLearner;
  final DataByCohortDistribution dataByCohortDistributionByYear;
  final DataByCohortDistribution dataByCohortDistributionByDistrict;

  SpecialEducationData({
    @required this.year,
    @required this.dataByGender,
    @required this.dataByEthnicity,
    @required this.dataBySpecialEdEnvironment,
    @required this.dataByEnglishLearner,
    @required this.dataByCohortDistributionByYear,
    @required this.dataByCohortDistributionByDistrict,
  });
}

class DataByGroup {
  final String title;
  final int firstValue;
  final int secondValue;
  int total;

  DataByGroup({
    @required this.title,
    @required this.firstValue,
    this.secondValue = 0,
  }) {
    total = firstValue + secondValue;
  }
}

class DataByCohortDistribution {
  final List<DataByCohort> environment;
  final List<DataByCohort> disability;
  final List<DataByCohort> etnicity;
  final List<DataByCohort> englishLearner;

  const DataByCohortDistribution({
    @required this.environment,
    @required this.disability,
    @required this.etnicity,
    @required this.englishLearner,
  });
}

class DataByCohort {
  final String cohortName;
  final List<DataByGroup> groupDataList;
  const DataByCohort({
    @required this.cohortName,
    @required this.groupDataList,
  });
}
