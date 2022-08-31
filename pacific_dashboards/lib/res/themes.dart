import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts
    show TextStyleSpec, Color, LineStyleSpec;

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.kBlue,
  accentColor: AppColors.kPeacockBlue,
  dialogTheme: DialogTheme(
    titleTextStyle: const TextStyle(
      color: AppColors.kTextMain,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
  ),
  fontFamily: 'NotoSans',
  iconTheme: const IconThemeData(color: Colors.white),
  splashColor: AppColors.kRipple,
  textTheme: const TextTheme(
    headline2: const TextStyle(
      color: Colors.white,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    headline3: const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    headline4: const TextStyle(
      color: AppColors.kTextMain,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    headline5: const TextStyle(
      color: AppColors.kTextMinor,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
    headline6: const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    subtitle1: const TextStyle(
      color: AppColors.kTextMain,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    button: const TextStyle(
      color: AppColors.kTextMain,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    subtitle2: const TextStyle(
      color: AppColors.kTextMain,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    overline: const TextStyle(
      color: AppColors.kTextMinor,
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
    ),
    bodyText1: const TextStyle(
      color: AppColors.kPeacockBlue,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontFamily: 'Roboto',
    ),
    bodyText2: const TextStyle(
      color: AppColors.kTextMinor,
      fontSize: 14.0,
      fontStyle: FontStyle.italic,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
  unselectedWidgetColor: AppColors.kBlue,
  toggleableActiveColor: AppColors.kBlue,
);

const charts.TextStyleSpec largeChartsDomain = const charts.TextStyleSpec(
  fontFamily: 'NotoSans',
  color: charts.Color(a: 255, r: 99, g: 105, b: 109),
  fontSize: 14,
);

const charts.TextStyleSpec smallChartsDomain = const charts.TextStyleSpec(
  fontFamily: 'NotoSans',
  color: charts.Color(a: 255, r: 99, g: 105, b: 109),
  fontSize: 0,
);

final chartAxisTextStyle = charts.TextStyleSpec(
  fontSize: 10,
  color: AppColors.kTextMinor.chartsColor,
);

final chartAxisLineStyle = charts.LineStyleSpec(
  color: AppColors.kCoolGray.chartsColor,
);

extension ChartsTextStyle on TextStyle {
  charts.TextStyleSpec get chartsSpec => charts.TextStyleSpec(
        fontFamily: this.fontFamily,
        color: this.color.chartsColor,
        fontSize: this.fontSize.round(),
        lineHeight: this.height,
      );
}

extension TextThemeExt on TextTheme {
  TextStyle get chartLegend => this.overline.copyWith(
        color: AppColors.kTextMain,
      );

  TextStyle get miniTab => this.button.copyWith(
        color: AppColors.kTextMinor,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      );

  TextStyle get miniTabSelected => this.miniTab.copyWith(
        color: AppColors.kPeacockBlue,
        fontWeight: FontWeight.bold,
      );

  TextStyle get individualDashboardsSubtitle =>
      this.headline4.copyWith(fontSize: 12);

  TextStyle get bigTab =>
      this.headline5.copyWith(fontSize: 12, letterSpacing: 0.25);

  TextStyle get individualDashboardsExamSubtitle =>
      this.headline5.copyWith(fontSize: 12, letterSpacing: 0.25);

  TextStyle get individualDashboardsExamBody =>
      this.individualDashboardsExamSubtitle.copyWith(
            fontWeight: FontWeight.normal,
          );

  TextStyle get individualDashboardsExamHistoryTableHeader =>
      this.subtitle2.copyWith(
            color: AppColors.kTextMinor,
          );

  TextStyle get individualDashboardsExamHistoryTableYearHeader =>
      this.subtitle2.copyWith(
            fontWeight: FontWeight.bold,
          );

  TextStyle get individualDashboardsExamHistoryTablePercentage =>
      this.overline.copyWith(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          );

  TextStyle get individualAccreditationInspectedBy => this.headline5.copyWith(
        fontSize: 12.0,
      );

  TextStyle get individualAccreditationLevel => this.overline.copyWith(
        fontSize: 12.0,
      );

  TextStyle get individualAccreditationStandard => this.overline.copyWith(
        color: AppColors.kTextMain,
        fontWeight: FontWeight.bold,
      );

  TextStyle get washSelectedQuestion => this.subtitle2.copyWith(
        color: AppColors.kBlueDark,
      );
}
