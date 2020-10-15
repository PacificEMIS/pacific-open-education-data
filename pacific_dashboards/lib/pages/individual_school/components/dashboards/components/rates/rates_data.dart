import 'package:flutter/material.dart';

class RatesData {
  final LastYearRatesData lastYearRatesData;
  final List<YearByClassLevelRateData> historicalData;

  const RatesData({
    @required this.lastYearRatesData,
    @required this.historicalData,
  });
}

class ClassLevelRatesData {
  final String classLevel;
  final double dropoutRate;
  final double promoteRate;
  final double repeatRate;
  final double survivalRate;

  const ClassLevelRatesData({
    @required this.classLevel,
    @required this.dropoutRate,
    @required this.promoteRate,
    @required this.repeatRate,
    @required this.survivalRate,
  });
}

class LastYearRatesData {
  final int year;
  final List<ClassLevelRatesData> data;

  const LastYearRatesData({
    @required this.year,
    @required this.data,
  });
}

class YearRateData {
  final int year;
  final double dropoutRate;
  final double promoteRate;
  final double repeatRate;
  final double survivalRate;

  const YearRateData({
    @required this.year,
    @required this.dropoutRate,
    @required this.promoteRate,
    @required this.repeatRate,
    @required this.survivalRate,
  });
}

class YearByClassLevelRateData {
  final String classLevel;
  final List<YearRateData> data;

  const YearByClassLevelRateData({
    @required this.classLevel,
    @required this.data,
  });
}
