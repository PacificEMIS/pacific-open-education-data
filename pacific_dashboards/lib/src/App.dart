import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/InjectorWidget.dart';
import 'package:pacific_dashboards/src/ui/exams_ui/ExamsPage.dart';
import 'package:pacific_dashboards/src/ui/home_ui/HomePage.dart';
import 'package:pacific_dashboards/src/ui/schools_ui/SchoolsPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pacific_dashboards/src/ui/teaches_ui/TeachersPage.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';

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
      supportedLocales: [const Locale('en', 'EN'), const Locale('de', 'DE')],
      onGenerateTitle: (BuildContext context) => AppLocalizations.appName,
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
        "/": (context) => HomePage(globalSettings: injector.globalSettings),
        "/Home": (context) => HomePage(globalSettings: injector.globalSettings),
        "/Budgets": (context) => AlertWindowBack(),
        "/Exams": (context) => ExamsPage(bloc: injector.examsBloc),
        "/Indicators": (context) => AlertWindowBack(),
        "/School Accreditations": (context) => AlertWindowBack(),
        "/Schools": (context) => SchoolsPage(bloc: injector.schoolsBloc),
        "/Teachers": (context) => TeachersPage(bloc: injector.teachersBloc),
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
