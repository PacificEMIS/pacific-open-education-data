import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AppColors {
  static const Color kBlue = const Color.fromARGB(255, 26, 115, 232);
  static const Color kRipple = const Color.fromARGB(50, 26, 115, 232);
  static const Color kPeacockBlue = const Color.fromARGB(255, 0, 92, 157);
  static const Color kTextMain = const Color.fromARGB(255, 19, 40, 38);
  static const Color kTextMinor = const Color.fromARGB(255, 99, 105, 109);
  static const Color kCoolGray = const Color.fromARGB(255, 196, 203, 206);
  static const Color kGeyser = const Color.fromARGB(255, 219, 224, 228);
  static const Color kGrayLight = const Color.fromARGB(255, 245, 246, 248);
  static const Color kTuna = const Color.fromARGB(255, 51, 55, 61);
  static const Color kRacingGreen = const Color.fromARGB(255, 17, 35, 19);
  static const Color kSpace = const Color.fromARGB(255, 239, 243, 248);
  static const Color kRed = const Color.fromARGB(255, 248, 84, 84);
  static const Color kGreen = const Color.fromARGB(255, 13, 211, 92);
  static const Color kOrange = const Color.fromARGB(255, 255, 149, 26);
  static const Color kYellow = const Color.fromARGB(255, 252, 204, 36);
  static const Color kLightGreen = const Color.fromARGB(255, 148, 220, 57);
  static const List<Color> kLevels = [
    kRed,
    kYellow,
    kLightGreen,
    kGreen,
  ];

  static const List<Color> kCertification = [
    kRed,
    kYellow,
    kLightGreen,
    kGreen,
    kRed,
    kYellow,
    kLightGreen,
    kGreen,
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
