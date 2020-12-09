import 'package:flutter/material.dart';

class ExamReportsFilteredData {
  const ExamReportsFilteredData({
    @required this.year,
    @required this.examName,
    @required this.byBenchmark,
    @required this.byGender,
  });

  final int year;
  final String examName;
  final ExamReportsBenchmarkResults byBenchmark;
  final ExamReportsGenderResults byGender;
}

class ExamReportsBenchmarkResults {
  const ExamReportsBenchmarkResults({
    @required this.maxNegativeCandidates,
    @required this.maxPositiveCandidates,
    @required this.dataByBenchmark,
  });

  final int maxNegativeCandidates;
  final int maxPositiveCandidates;
  final List<ExamReportsBenchmarkData> dataByBenchmark;
}

class ExamReportsBenchmarkData {
  const ExamReportsBenchmarkData({
    @required this.benchmarkCode,
    @required this.benchmarkDescription,
    @required this.wellBelowCount,
    @required this.approachingCount,
    @required this.minimallyCount,
    @required this.competentCount,
  });

  final String benchmarkCode;
  final String benchmarkDescription;
  final int wellBelowCount;
  final int approachingCount;
  final int minimallyCount;
  final int competentCount;
}

class ExamReportsGenderResults {
  const ExamReportsGenderResults({
    @required this.maxFemaleCandidates,
    @required this.maxMaleCandidates,
    @required this.competentData,
    @required this.minimallyData,
    @required this.approachingData,
    @required this.wellBelowData,
  });

  final int maxFemaleCandidates;
  final int maxMaleCandidates;
  final ExamReportsGenderData competentData;
  final ExamReportsGenderData minimallyData;
  final ExamReportsGenderData approachingData;
  final ExamReportsGenderData wellBelowData;
}

class ExamReportsGenderData {
  ExamReportsGenderData({
    @required this.male,
    @required this.female,
  });

  int male;
  int female;
}

class ExamReportsHistoryByYearData {
  ExamReportsHistoryByYearData({
    @required this.year,
    @required this.rows,
  });

  int year;
  List<ExamReportsHistoryRowData> rows;
}

class ExamReportsHistoryRowData {
  ExamReportsHistoryRowData({
    @required this.examCode,
    @required this.examName,
    @required this.male,
    @required this.female,
  }) {
    total = male + female;
    if (total == 0) {
      malePercent = 0;
      femalePercent = 0;
    } else {
      malePercent = (male / total * 100).round();
      femalePercent = (female / total * 100).round();
    }
  }

  String examCode;
  String examName;
  int male;
  int female;
  int total;
  int malePercent;
  int femalePercent;
}
