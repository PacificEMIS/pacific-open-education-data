import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/schools_ui/SchoolsPage.dart';
import 'package:pacific_dashboards/src/ui/splash_ui/SplashPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/ExamsModel.dart';
import 'ui/exams_ui/ExamsPage.dart';
import 'ui/home_ui/HomePage.dart';
import 'ui/InjectorWidget.dart';
import 'ui/teaches_ui/TeachersPage.dart';
import 'ui/StackedHorizontalBarChart.dart';
import 'utils/Localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final injector = InjectorWidget.of(context);
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('en'), const Locale('ru')],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.deepOrangeAccent[100],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>
            SplashPage(globalSettings: injector.getGlobalSettings()),
        "/Home": (context) =>
            HomePage(globalSettings: injector.getGlobalSettings()),
        "/Budgets": (context) => AlertWindowBack(),
        "/Exams": (context) => ExamsPage(bloc: injector.getExamsBloc()),
        "/Indicators": (context) => AlertWindowBack(),
        "/School Accreditations": (context) => AlertWindowBack(),
        "/Schools": (context) => SchoolsPage(bloc: injector.getSchoolsBloc()),
        "/Teachers": (context) =>
            TeachersPage(bloc: injector.getTeachersBloc()),
      },
    );
  }
}

class AlertWindowBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AlertDialog(
          title: Text(AppLocalizations.construction),
          content: Text(AppLocalizations.constructionDescription),
        ),
      ),
    );
  }
}
