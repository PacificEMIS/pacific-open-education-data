import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:pacific_dashboards/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
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
  static String get construction => Intl.message("Construction", name: "construction");
  static String get constructionDescription => Intl.message("This section is under construction", name: "constructionDescription");
  // Home
  static String get marshallIslands => Intl.message("Marshall Islands", name: "marshallIslands");
  static String get federatedStateOfMicronesia => Intl.message("Federated States of Micronesia",name: "federatedStateOfMicronesia");
  static String get federatedStateOfMicronesiaSplitted => Intl.message("Federated States \nof Micronesia",  name: "federatedStateOfMicronesiaSplitted");
  static String get changeCountry => Intl.message("Change country", name: "changeCountry");
  static String get choiceCountry => Intl.message("Choice country", name: "choiceCountry");

  static String get schools => Intl.message("Schools", name: "schools");
  static String get teachers => Intl.message("Teachers", name: "teachers");
  static String get exams => Intl.message("Exams", name: "exams");
  static String get schoolaccreditations => Intl.message("School Accreditations", name: "schoolaccreditations");
  static String get indicators => Intl.message("Indicators", name: "indicators");
  static String get budgets => Intl.message("Budgets", name: "budgets");
  // Exams
  static String get exam => Intl.message("Exam", name: "exam");
  static String get view => Intl.message("View", name: "view");
  static String get filterByStandart => Intl.message("Filter by standart", name: "filterByStandart");
  // Schools
  static String get schoolsEnrollment => Intl.message("Schools Enrollment", name: "schoolsEnrollment");
  static String get dislplayAllStates => Intl.message("Display All States", name: "dislplayAllStates");
  static String get displayAllAutority => Intl.message("Display All Authority", name: "displayAllAutority");
  static String get displayAllGovermant => Intl.message("Display all Govermant filters", name: "displayAllGovermant");
  static String get displayAllLevelFilters => Intl.message("Display all Level filters", name: "displayAllLevelFilters");
  static String get schoolsEnrollmentByState => Intl.message("Schools Enrollment by State", name: "schoolsEnrollmentByState");
  static String get schoolsEnrollmentByAutority => Intl.message("Schools Enrollment by Authority", name: "schoolsEnrollmentByAutority");
  static String get schoolsEnrollmentGovtNonGovt => Intl.message("Schools Enrollment Govt / \nNon-govt", name: "schoolsEnrollmentGovtNonGovt");
  static String get publicPrivate => Intl.message("Public/Private", name: "publicPrivate");
  static String get state => Intl.message("State", name: "state");
  static String get autority => Intl.message("Autority", name: "autority");
  static String get earlyChildhood => Intl.message('Early Childhood', name: "earlyChildhood");
  static String get primary => Intl.message("Primary", name: "primary");
  static String get secondary => Intl.message("Secondary", name: "secondary");
  static String get postsecondary => Intl.message("Post Secondary", name: "postsecondary");
  static String get total => Intl.message("Total", name: "total");
  static String get age => Intl.message("Age", name: "age");
  static String get schoolsEnrollmentByAgeEducationLevel => Intl.message("Schools Enrollment by Age, Education \nLevel and Gender", name: "schoolsEnrollmentByAgeEducationLevel");
  static String get schoolsEnrollmentBySchoolTypeStateAndGender => Intl.message("Schools Enrollment by School type, \nState and Gender", name: "schoolsEnrollmentBySchoolTypeStateAndGender");
  static String get schoolType => Intl.message("School \nType", name: "schoolType");
  //Teachers
  static String get displayAllGovermantFilters => Intl.message('Display all Govermant filters', name: "displayAllGovermantFilters");
  static String get displayAllLevel => Intl.message('Display all level filters', name: "displayAllLevel");
  static String get teachersByAutority => Intl.message("Teachers by Authority", name: "teachersByAutority");
  static String get teachersByState => Intl.message("Teachers by State", name: "teachersByState");
    static String get splash => Intl.message("\nPACIFIC OPEN\n EDUCATION DATA", name: "splash");
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
