import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pacific_dashboards/pages/budgets/budget_page.dart';
import 'package:pacific_dashboards/pages/download/download_page.dart';
import 'package:pacific_dashboards/pages/exams/exams_page.dart';
import 'package:pacific_dashboards/pages/home/inner_page/onboarding_page.dart';
import 'package:pacific_dashboards/pages/home/home_page.dart';
import 'package:pacific_dashboards/pages/indicators/indicators_page.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_page.dart';
import 'package:pacific_dashboards/pages/special_education/special_education_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page.dart';
import 'package:pacific_dashboards/pages/wash/wash_page.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({Key key,
    @required this.hideOnboarding,
  }) : super(key: key);

  final bool hideOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        StringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
      ],
      onGenerateTitle: (BuildContext context) => 'appName'.localized(context),
      theme: appTheme,
      initialRoute: hideOnboarding ? HomePage.kRoute : OnboardingPage.kRoute,
      routes: {
        OnboardingPage.kRoute: (context) => OnboardingPage(),
        HomePage.kRoute: (context) => HomePage(),
        SchoolsPage.kRoute: (context) => SchoolsPage(),
        TeachersPage.kRoute: (context) => TeachersPage(),
        SchoolAccreditationsPage.kRoute: (context) => SchoolAccreditationsPage(),
        ExamsPage.kRoute: (context) => ExamsPage(),
        SchoolsListPage.kRoute: (context) => SchoolsListPage(),
        IndividualSchoolPage.kRoute: (context) => IndividualSchoolPage(),
        BudgetsPage.kRoute: (context) => BudgetsPage(),
        WashPage.kRoute: (context) => WashPage(),
        IndicatorsPage.kRoute: (context) => IndicatorsPage(),
        SpecialEducationPage.kRoute: (context) => SpecialEducationPage(),
        DownloadPage.kRoute: (context) => DownloadPage(),
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
          title: Text('notImplementedTitle'.localized(context)),
          content: Text('notImplementedMessage'.localized(context)),
        ),
      ),
    );
  }
}
