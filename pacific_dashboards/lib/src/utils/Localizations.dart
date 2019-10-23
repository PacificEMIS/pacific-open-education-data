import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:pacific_dashboards/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

// Update arb flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/src/utils/localizations.dart
  // App
  static String get appName => Intl.message("Custom Charts", name: "appName");
  static String get construction =>
      Intl.message("Construction", name: "construction");
  static String get constructionDescription =>
      Intl.message("This section is under construction",
          name: "constructionDescription");
  // Home
  static String get marshallIslands =>
      Intl.message("Marshall Islands", name: "marshallIslands");
  static String get federatedStateOfMicronesia =>
      Intl.message("Federated States of Micronesia",
          name: "federatedStateOfMicronesia");
  static String get federatedStateOfMicronesiaSplitted =>
      Intl.message("Federated States \nof Micronesia",
          name: "federatedStateOfMicronesiaSplitted");
  static String get changeCountry =>
      Intl.message("Change country", name: "changeCountry");

  static String get schools => Intl.message("Schools", name: "schools");
  static String get teachers => Intl.message("Teachers", name: "teachers");
  static String get exams => Intl.message("Exams", name: "exams");
  static String get schoolAccreditations =>
      Intl.message("School Accreditations", name: "schoolAccreditations");
  static String get indicators =>
      Intl.message("Indicators", name: "indicators");
  static String get budgets => Intl.message("Budgets", name: "budgets");
  // Exams
  static String get exam => Intl.message("Exam", name: "exam");
  static String get view => Intl.message("View", name: "view");
  static String get filterByStandard =>
      Intl.message("Filter by standard", name: "filterByStandard");
  // Schools
  static String get schoolsEnrollment =>
      Intl.message("Schools Enrollment", name: "schoolsEnrollment");
  static String get displayAllStates =>
      Intl.message("Display All States", name: "displayAllStates");
  static String get displayAllAuthority =>
      Intl.message("Display All Authority", name: "displayAllAuthority");
  static String get displayAllGovernment =>
      Intl.message("Display all Govermant filters",
          name: "displayAllGovernment");
  static String get displayAllLevelFilters =>
      Intl.message("Display all Level filters", name: "displayAllLevelFilters");
  static String get schoolsEnrollmentByState =>
      Intl.message("Schools Enrollment by State",
          name: "schoolsEnrollmentByState");
  static String get schoolsEnrollmentByAuthority =>
      Intl.message("Schools Enrollment by Authority",
          name: "schoolsEnrollmentByAuthority");
  static String get schoolsEnrollmentGovtNonGovt =>
      Intl.message("Schools Enrollment Govt / \nNon-govt",
          name: "schoolsEnrollmentGovtNonGovt");
  static String get publicPrivate =>
      Intl.message("Public/Private", name: "publicPrivate");
  static String get state => Intl.message("State", name: "state");
  static String get authority => Intl.message("Authority", name: "authority");
  static String get earlyChildhood =>
      Intl.message('Early Childhood', name: "earlyChildhood");
  static String get primary => Intl.message("Primary", name: "primary");
  static String get secondary => Intl.message("Secondary", name: "secondary");
  static String get postSecondary =>
      Intl.message("Post Secondary", name: "postSecondary");
  static String get total => Intl.message("Total", name: "total");
  static String get age => Intl.message("Age", name: "age");
  static String get schoolsEnrollmentByAgeEducationLevel =>
      Intl.message("Schools Enrollment by Age, Education \nLevel and Gender",
          name: "schoolsEnrollmentByAgeEducationLevel");
  static String get schoolsEnrollmentBySchoolTypeStateAndGender =>
      Intl.message("Schools Enrollment by School Levels, \nState and Gender",
          name: "schoolsEnrollmentBySchoolTypeStateAndGender");
  static String get schoolType =>
      Intl.message("School \nLevels", name: "schoolType");
        static String get schoolLevels =>
      Intl.message("School \nLevels", name: "schoolLevels");
  //Filter
  static String get filterByYear =>
      Intl.message("Filter by year", name: "filterByYear");
  static String get filterByState =>
      Intl.message("Filter by state", name: "filterByState");
  static String get filterBySchoolType =>
      Intl.message("Teachers by School Levels, State and Gender",
          name: "filterBySchoolType");
  static String get filterByAuthority =>
      Intl.message("Filter by authority", name: "filterByAuthority");
  static String get filterByGovernment =>
      Intl.message("Filter by government", name: "filterByGovernment");
  static String get filterByClassLevel =>
      Intl.message("Filter by class level", name: "filterByClassLevel");
  //Teachers
  static String get displayAllGovernmentFilters =>
      Intl.message('Display all Government filters',
          name: "displayAllGovernmentFilters");
  static String get displayAllLevel =>
      Intl.message('Display all level filters', name: "displayAllLevel");
  static String get teachersByAuthority =>
      Intl.message("Teachers by Authority", name: "teachersByAuthority");
  static String get teachersByState =>
      Intl.message("Teachers by State", name: "teachersByState");
  static String get teacherBySchoolTypeStateAndGender =>
      Intl.message("Teacher by School Levels, \nState and Gender",
          name: "teacherBySchoolTypeStateAndGender");
  static String get teachersEnrollmentGovtNonGovt =>
      Intl.message("Teachers by Govt / \nNon-govt",
          name: "teachersEnrollmentGovtNonGovt");
  //School accreditations
  static String get accreditationProgress =>
      Intl.message("Accreditation Progress", name: "accreditationProgress");
  static String get districtStatus =>
      Intl.message("District Status", name: "districtStatus");

  static String get filterBySelectedYear =>
      Intl.message("Selected Year", name: "filterBySelectedYear");
  static String get filterBySelectedState =>
      Intl.message("Selected State", name: "filterBySelectedState");
  static String get filterBySelectedGovtNonGovt =>
      Intl.message("Selected Govt / Non-govt",
          name: "filterBySelectedGovtNonGovt");
  static String get filterBySelectedAuthority =>
      Intl.message("Selected Authority", name: "filterBySelectedAuthority");
  static String get filterBySelectedSchoolLevel =>
      Intl.message("Selected School Levels",
          name: "filterBySelectedSchoolLevels");

  static String get standard =>
      Intl.message("Standard ",
          name: "standard");
  static String get accreditationStatusByState =>
      Intl.message("Accreditation Status by State ",
          name: "accreditationStatusByState");
  static String get accreditationPerfomancebyStandard =>
      Intl.message("Performance by Standard ",
          name: "accreditationPerfomancebyStandard");

  static String get splash =>
      Intl.message("\nPACIFIC OPEN\n EDUCATION DATA", name: "splash");
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["en", "de"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
