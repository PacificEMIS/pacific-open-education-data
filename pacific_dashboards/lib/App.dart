import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pacific_dashboards/pages/exams/exams_page.dart';
import 'package:pacific_dashboards/pages/home/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/home/home_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/injector_widget.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final injector = InjectorWidget.of(context);
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('ru')],
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
      initialRoute: HomePage.kRoute,
      routes: {
        HomePage.kRoute: (context) => BlocProvider(
              builder: (context) {
                return injector.homeBloc
                  ..add(StartedHomeEvent());
              },
              child: HomePage(),
            ),
        "/Budgets": (context) => _NotImplementedPage(),
        "/Exams": (context) => ExamsPage(bloc: injector.examsBloc),
        "/Indicators": (context) => _NotImplementedPage(),
        "/School Accreditations": (context) =>
            SchoolAccreditationsPage(bloc: injector.schoolAccreditationsBloc),
        "/Schools": (context) => SchoolsPage(bloc: injector.schoolsBloc),
        "/Teachers": (context) => TeachersPage(bloc: injector.teachersBloc),
      },
    );
  }
}

class _NotImplementedPage extends StatelessWidget {
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
