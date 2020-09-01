import 'package:flutter/foundation.dart';

class SpecialEducationData {
  final List<DataByGroup> dataByGender;
  final List<DataByGroup> dataByEthnicity;
  final List<DataByGroup> dataBySpecialEdEnvironment;
  final List<DataByGroup> dataByEnglishLearner;
  final Map<String, Map<String, List<DataByGroup>>>
      dataByCohortDistributionByYear;
  final Map<String, Map<String, List<DataByGroup>>>
      dataByCohortDistributionByState;

  SpecialEducationData(
      {@required this.dataByGender,
      @required this.dataByEthnicity,
      @required this.dataBySpecialEdEnvironment,
      @required this.dataByEnglishLearner,
      @required this.dataByCohortDistributionByYear,
      @required this.dataByCohortDistributionByState});
}

class DataByGroup {
  final String title;
  final int firstValue;
  final int secondValue;
  int total;

  DataByGroup({
    @required this.title,
    @required this.firstValue,
    @required this.secondValue,
  }) {
    total = firstValue + secondValue;
  }
}
