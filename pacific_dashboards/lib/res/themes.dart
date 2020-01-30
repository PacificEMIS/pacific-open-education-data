import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.kRoyalBlue,
  accentColor: AppColors.kEndeavour,
  fontFamily: 'NotoSans',
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    display3: const TextStyle(
      color: Colors.white,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    display2: const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    display1: const TextStyle(
      color: AppColors.kTimberGreen,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    headline: const TextStyle(
      color: AppColors.kNevada,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    title: const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    subhead: const TextStyle(
      color: AppColors.kTimberGreen,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    button: const TextStyle(
      color: AppColors.kTimberGreen,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    subtitle: const TextStyle(
      color: AppColors.kTimberGreen,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    overline: const TextStyle(
      color: AppColors.kNevada,
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    body2: const TextStyle(
      color: AppColors.kEndeavour,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontFamily: 'Roboto',
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
);
