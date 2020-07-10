import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pacific_dashboards/pages/exams/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/exams/exams_page.dart';
import 'package:pacific_dashboards/pages/home/home_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_page.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/schools/schools_page.dart';
import 'package:pacific_dashboards/pages/schools_list/bloc/schools_list_bloc.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_page.dart';
import 'package:pacific_dashboards/pages/teachers/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';

import 'pages/school_accreditation/bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
        const Locale('he')
      ],
      onGenerateTitle: (BuildContext context) => AppLocalizations.appName,
      theme: appTheme,
      initialRoute: HomePage.kRoute,
      routes: {
        HomePage.kRoute: (context) => HomePage(),
        SchoolsPage.kRoute: (context) => SchoolsPage(),
//        ExamsPage.kRoute: (context) => BlocProvider<ExamsBloc>(
//              create: (context) {
//                return injector.examsBloc..add(StartedExamsEvent());
//              },
//              child: ExamsPage(),
//            ),
//        SchoolAccreditationsPage.kRoute: (context) =>
//            BlocProvider<AccreditationBloc>(
//              create: (context) {
//                return injector.schoolAccreditationsBloc
//                  ..add(StartedAccreditationEvent());
//              },
//              child: SchoolAccreditationsPage(),
//            ),
//        TeachersPage.kRoute: (context) => BlocProvider<TeachersBloc>(
//              create: (context) {
//                return injector.teachersBloc..add(StartedTeachersEvent());
//              },
//              child: TeachersPage(),
//            ),
//        SchoolsListPage.kRoute: (context) => BlocProvider<SchoolsListBloc>(
//              create: (context) {
//                return injector.schoolsListBloc..add(StartedSchoolsListEvent());
//              },
//              child: SchoolsListPage(),
//            ),
        "/Budgets": (context) => _NotImplementedPage(),
        "/Indicators": (context) => _NotImplementedPage(),
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
