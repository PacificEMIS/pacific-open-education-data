import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/exams/exams_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page.dart';
import 'package:pacific_dashboards/res/strings.dart';

enum Section {
  schools,
  teachers,
  exams,
  schoolAccreditations,
  indicators,
  budgets,
  individualSchools
}

extension UI on Section {
  String get logoPath {
    switch (this) {
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
      case Section.individualSchools:
        return "images/budgets.svg"; // TODO: waiting for icon
    }
    throw FallThroughError();
  }

  String getName(BuildContext context) {
    switch (this) {
      case Section.schools:
        return 'homeSectionSchoolsDashboards'.localized(context);
      case Section.teachers:
        return 'homeSectionTeachersDashboards'.localized(context);
      case Section.schoolAccreditations:
        return 'homeSectionSchoolsAccreditationDashboards'.localized(context);
      case Section.indicators:
        return 'homeSectionIndicators'.localized(context);
      case Section.budgets:
        return 'homeSectionBudgets'.localized(context);
      case Section.exams:
        return 'homeSectionExamsDashboards'.localized(context);
      case Section.individualSchools:
        return 'homeSectionIndividualSchools'.localized(context);
    }

    throw FallThroughError();
  }

  String get routeName {
    switch (this) {
      case Section.schools:
        return SchoolsPage.kRoute;
      case Section.teachers:
        return TeachersPage.kRoute;
      case Section.schoolAccreditations:
        return SchoolAccreditationsPage.kRoute;
      case Section.exams:
        return ExamsPage.kRoute;
      case Section.indicators:
        return "/Indicators";
      case Section.budgets:
        return "/Budgets";
      case Section.individualSchools:
        return SchoolsListPage.kRoute;
    }

    throw FallThroughError();
  }
}
