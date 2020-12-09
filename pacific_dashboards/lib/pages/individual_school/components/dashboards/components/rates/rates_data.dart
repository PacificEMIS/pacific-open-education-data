import 'package:flutter/material.dart';

class RatesData {
  const RatesData({
    @required this.lastYearRatesData,
    @required this.historicalData,
  });

  final LastYearRatesData lastYearRatesData;
  final List<YearByClassLevelRateData> historicalData;
}

class ClassLevelRatesData {
  const ClassLevelRatesData({
    @required this.classLevel,
    @required this.dropoutRate,
    @required this.promoteRate,
    @required this.repeatRate,
    @required this.survivalRate,
  });

  final String classLevel;
  final double dropoutRate;
  final double promoteRate;
  final double repeatRate;
  final double survivalRate;
}

class LastYearRatesData {
  const LastYearRatesData({
    @required this.year,
    @required this.data,
  });

  final int year;
  final List<ClassLevelRatesData> data;
}

class YearRateData {
  const YearRateData({
    @required this.year,
    @required this.dropoutRate,
    @required this.promoteRate,
    @required this.repeatRate,
    @required this.survivalRate,
  });

  final int year;
  final double dropoutRate;
  final double promoteRate;
  final double repeatRate;
  final double survivalRate;
}

class YearByClassLevelRateData {
  const YearByClassLevelRateData({
    @required this.classLevel,
    @required this.data,
  });

  final String classLevel;
  final List<YearRateData> data;
}
