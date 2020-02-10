import 'package:flutter/material.dart';

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
