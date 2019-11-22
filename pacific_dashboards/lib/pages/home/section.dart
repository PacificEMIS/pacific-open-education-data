import 'package:pacific_dashboards/res/strings/strings.dart';

enum Section {
  schools,
  teachers,
  exams,
  schoolAccreditations,
  indicators,
  budgets
}

String logoPathForSection(Section section) {
  switch (section) {
    case Section.schools:
      return "images/schools.svg";
    case Section.teachers:
      return "images/teachers.svg";
    case Section.schoolAccreditations:
      return "images/school_accreditations.svg";
    case Section.exams:
      return "images/exams.svg";
    case Section.indicators:
      return "images/indicators.svg";
    case Section.budgets:
      return "images/budgets.svg";
    default:
      throw FallThroughError();
  }
}

String nameOfSection(Section section) {
  switch (section) {
    case Section.schools:
      return AppLocalizations.schools;
    case Section.teachers:
      return AppLocalizations.teachers;
    case Section.schoolAccreditations:
      return AppLocalizations.schoolAccreditations;
    case Section.indicators:
      return AppLocalizations.indicators;
    case Section.budgets:
      return AppLocalizations.budgets;
    case Section.exams:
      return AppLocalizations.exams;
    default:
      throw FallThroughError();
  }
}

String routeNameOfSection(Section section) {
  switch (section) {
    case Section.schools:
      return "/Schools";
    case Section.teachers:
      return "/Teachers";
    case Section.schoolAccreditations:
      return "/School Accreditations";
    case Section.exams:
      return "/Exams";
    case Section.indicators:
      return "/Indicators";
    case Section.budgets:
      return "/Budgets";
    default:
      throw FallThroughError();
  }
}