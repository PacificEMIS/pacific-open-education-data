import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/budgets/budget_page.dart';
import 'package:pacific_dashboards/pages/exams/exams_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_page.dart';
import 'package:pacific_dashboards/pages/special_education/special_education_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page.dart';
import 'package:pacific_dashboards/res/strings.dart';

enum Section {
  schools,
  teachers,
  exams,
  schoolAccreditations,
  indicators,
  budgets,
  wash,
  individualSchools,
  specialEducation,
}

extension UI on Section {
  String get logoPath {
    switch (this) {
      case Section.schools:
        return "images/ic_schools.png";
      case Section.teachers:
        return "images/ic_teachers.png";
      case Section.schoolAccreditations:
        return "images/ic_school_accreditations.png";
      case Section.exams:
        return "images/ic_exams.png";
      case Section.indicators:
        return "images/ic_indicators.png";
      case Section.budgets:
        return "images/ic_budgets.png";
      case Section.individualSchools:
        return "images/ic_individual_schools.png";
      case Section.specialEducation:
        return "images/ic_special_education.png";
      case Section.wash:
        return "images/ic_wash.png";
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
      case Section.specialEducation:
        return 'homeSectionSpecialEducation'.localized(context);
      case Section.wash:
        return 'homeSectionWash'.localized(context);
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
      case Section.wash:
        return "/Wash";
      case Section.budgets:
        return BudgetsPage.kRoute;
      case Section.individualSchools:
        return SchoolsListPage.kRoute;
      case Section.specialEducation:
        return SpecialEducationPage.kRoute;
        break;
    }

    throw FallThroughError();
  }
}
