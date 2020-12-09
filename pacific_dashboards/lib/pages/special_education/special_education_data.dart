import 'package:flutter/foundation.dart';

class SpecialEducationData {
  const SpecialEducationData({
    @required this.year,
    @required this.dataByGender,
    @required this.dataByEthnicity,
    @required this.dataBySpecialEdEnvironment,
    @required this.dataByEnglishLearner,
    @required this.dataByCohortDistributionByYear,
    @required this.dataByCohortDistributionByDistrict,
  });

  final int year;
  final List<DataByGroup> dataByGender;
  final List<DataByGroup> dataByEthnicity;
  final List<DataByGroup> dataBySpecialEdEnvironment;
  final List<DataByGroup> dataByEnglishLearner;
  final DataByCohortDistribution dataByCohortDistributionByYear;
  final DataByCohortDistribution dataByCohortDistributionByDistrict;
}

class DataByGroup {
  DataByGroup({
    @required this.title,
    @required this.firstValue,
    this.secondValue = 0,
  }) {
    total = firstValue + secondValue;
  }

  final String title;
  final int firstValue;
  final int secondValue;
  int total;
}

class DataByCohortDistribution {
  const DataByCohortDistribution({
    @required this.environment,
    @required this.disability,
    @required this.etnicity,
    @required this.englishLearner,
  });

  final List<DataByCohort> environment;
  final List<DataByCohort> disability;
  final List<DataByCohort> etnicity;
  final List<DataByCohort> englishLearner;
}

class DataByCohort {
  const DataByCohort({
    @required this.cohortName,
    @required this.groupDataList,
  });

  final String cohortName;
  final List<DataByGroup> groupDataList;
}
