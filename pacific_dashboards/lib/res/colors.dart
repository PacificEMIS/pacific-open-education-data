import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AppColors {
  static const Color kRoyalBlue = const Color.fromARGB(255, 26, 115, 232);
  static const Color kEndeavour = const Color.fromARGB(255, 0, 92, 157);
  static const Color kTimberGreen = const Color.fromARGB(255, 19, 40, 38);
  static const Color kNevada = const Color.fromARGB(255, 99, 105, 109);
  static const Color kLoblolly = const Color.fromARGB(255, 196, 203, 206);
  static const Color kGeyser = const Color.fromARGB(255, 219, 224, 228);
  static const Color kAthensGray = const Color.fromARGB(255, 245, 246, 248);
  static const Color kTuna = const Color.fromARGB(255, 51, 55, 61);
  static const Color kRacingGreen = const Color.fromARGB(255, 17, 35, 19);
  
  static const List<Color> kLevels = [
    const Color.fromARGB(255, 248, 84, 84),
    const Color.fromARGB(255, 255, 186, 10),
    const Color.fromARGB(255, 148, 220, 57),
    const Color.fromARGB(255, 13, 211, 92),
  ];
}


extension ChartColor on Color {
  charts.Color get chartsColor => charts.Color(
        r: red,
        g: green,
        b: blue,
        a: alpha,
      );
}