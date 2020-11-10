import 'package:flutter/material.dart';

class ExamReportsFilteredData {
  final int year;
  final String examName;
  final ExamReportsBenchmarkResults byBenchmark;
  final ExamReportsGenderResults byGender;

  const ExamReportsFilteredData({
    @required this.year,
    @required this.examName,
    @required this.byBenchmark,
    @required this.byGender,
  });
}

class ExamReportsBenchmarkResults {
  final int maxNegativeCandidates;
  final int maxPositiveCandidates;
  final List<ExamReportsBenchmarkData> dataByBenchmark;

  const ExamReportsBenchmarkResults({
    @required this.maxNegativeCandidates,
    @required this.maxPositiveCandidates,
    @required this.dataByBenchmark,
  });
}

class ExamReportsBenchmarkData {
  final String benchmarkCode;
  final String benchmarkDescription;
  final int wellBelowCount;
  final int approachingCount;
  final int minimallyCount;
  final int competentCount;

  const ExamReportsBenchmarkData({
    @required this.benchmarkCode,
    @required this.benchmarkDescription,
    @required this.wellBelowCount,
    @required this.approachingCount,
    @required this.minimallyCount,
    @required this.competentCount,
  });
}

class ExamReportsGenderResults {
  final int maxFemaleCandidates;
  final int maxMaleCandidates;
  final ExamReportsGenderData competentData;
  final ExamReportsGenderData minimallyData;
  final ExamReportsGenderData approachingData;
  final ExamReportsGenderData wellBelowData;

  const ExamReportsGenderResults({
    @required this.maxFemaleCandidates,
    @required this.maxMaleCandidates,
    @required this.competentData,
    @required this.minimallyData,
    @required this.approachingData,
    @required this.wellBelowData,
  });
}

class ExamReportsGenderData {
  int male;
  int female;

  ExamReportsGenderData({
    @required this.male,
    @required this.female,
  });
}

class ExamReportsHistoryByYearData {
  int year;
  List<ExamReportsHistoryRowData> rows;

  ExamReportsHistoryByYearData({
    @required this.year,
    @required this.rows,
  });
}

class ExamReportsHistoryRowData {
  String examCode;
  String examName;
  int male;
  int female;
  int total;
  int malePercent;
  int femalePercent;

  ExamReportsHistoryRowData({
    @required this.examCode,
    @required this.examName,
    @required this.male,
    @required this.female,
  }) {
    total = male + female;
    if (total == 0) { malePercent = 0; femalePercent = 0;}
    else {malePercent = (male / total * 100).round();
    femalePercent = (female / total * 100).round();}
  }
}
