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
    const Color.fromRGBO(248, 84, 84, 1),
    const Color.fromRGBO(255, 220, 38, 1),
    const Color.fromRGBO(148, 220, 57, 1),
    const Color.fromRGBO(13, 211, 92, 1),
  ];

  static const List<Color> kDistricts = [
    const Color.fromRGBO(26, 115, 232, 1),
    const Color.fromRGBO(32, 209, 103, 1),
    const Color.fromRGBO(255, 220, 38, 1),
    const Color.fromRGBO(255, 149, 26, 1),
    const Color.fromRGBO(2, 185, 243, 1),
    const Color.fromRGBO(119, 220, 57, 1),
    const Color.fromRGBO(248, 84, 84, 1),
    const Color.fromRGBO(0, 92, 157, 1),
    const Color.fromRGBO(199, 57, 208, 1),
    const Color.fromRGBO(43, 216, 216, 1),
    const Color.fromRGBO(40, 136, 128, 1),
    const Color.fromRGBO(255, 189, 89, 1),
    const Color.fromRGBO(204, 67, 95, 1),
    const Color.fromRGBO(97, 82, 159, 1),
    const Color.fromRGBO(173, 86, 205, 1),
    const Color.fromRGBO(1, 193, 118, 1),
    const Color.fromRGBO(136, 193, 0, 1),
    const Color.fromRGBO(246, 105, 81, 1),
    const Color.fromRGBO(221, 1, 53, 1),
    const Color.fromRGBO(0, 61, 104, 1),
    const Color.fromRGBO(17, 76, 153, 1),
    const Color.fromRGBO(1, 122, 160, 1),
    const Color.fromRGBO(0, 115, 46, 1),
    const Color.fromRGBO(168, 98, 16, 1),
    const Color.fromRGBO(196, 203, 206, 1),
  ];

  static const Color kGovernmentChartColor =
      const Color.fromRGBO(26, 115, 232, 1);
  static const Color kNonGovernmentChartColor =
      const Color.fromRGBO(2, 185, 243, 1);
}

extension ChartColor on Color {
  charts.Color get chartsColor => charts.Color(
        r: red,
        g: green,
        b: blue,
        a: alpha,
      );
}

class HexColor extends Color {
  final String hexColor;

  HexColor(this.hexColor) : super(_getColorFromHex(hexColor));

  factory HexColor.fromStringHash(String str) {
    return HexColor(_getColorFromStringHash(str));
  }

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  static String _getColorFromStringHash(String str) {
    var seed = 75;
    var c = (str.hashCode * seed & 0x00FFFFFF).toRadixString(16).toUpperCase();

    return "#" + "00000".substring(0, 6 - c.length) + c;
  }
}
