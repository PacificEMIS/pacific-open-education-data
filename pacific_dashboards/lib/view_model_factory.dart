import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/exams/exams_view_model.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_view_model.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_view_model.dart';
import 'package:pacific_dashboards/pages/schools/schools_view_model.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_view_model.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_view_model.dart';
import 'package:pacific_dashboards/service_locator.dart';

class ViewModelFactory {
  static ViewModelFactory _instance;

  static ViewModelFactory get instance {
    if (_instance == null) {
      _instance = ViewModelFactory._();
    }
    return _instance;
  }

  ViewModelFactory._();

  HomeViewModel createHomeViewModel(BuildContext ctx) {
    return HomeViewModel(
      ctx,
      globalSettings: serviceLocator.globalSettings,
      remoteConfig: serviceLocator.remoteConfig,
    );
  }

  SchoolsViewModel createSchoolsViewModel(BuildContext ctx) {
    return SchoolsViewModel(
      ctx,
      repository: serviceLocator.repository,
      remoteConfig: serviceLocator.remoteConfig,
      globalSettings: serviceLocator.globalSettings,
    );
  }

  TeachersViewModel createTeachersViewModel(BuildContext ctx) {
    return TeachersViewModel(
      ctx,
      repository: serviceLocator.repository,
      remoteConfig: serviceLocator.remoteConfig,
      globalSettings: serviceLocator.globalSettings,
    );
  }

  SchoolAccreditationViewModel createSchoolAccreditationViewModel(
      BuildContext ctx) {
    return SchoolAccreditationViewModel(
      ctx,
      repository: serviceLocator.repository,
      remoteConfig: serviceLocator.remoteConfig,
      globalSettings: serviceLocator.globalSettings,
    );
  }

  ExamsViewModel createExamsViewModel(BuildContext ctx) {
    return ExamsViewModel(
      ctx,
      repository: serviceLocator.repository,
      remoteConfig: serviceLocator.remoteConfig,
      globalSettings: serviceLocator.globalSettings,
    );
  }

  SchoolsListViewModel createIndividualSchoolsList(BuildContext ctx) {
    return SchoolsListViewModel(
      ctx,
      repository: serviceLocator.repository,
      remoteConfig: serviceLocator.remoteConfig,
      globalSettings: serviceLocator.globalSettings,
    );
  }

  IndividualSchoolViewModel createIndividualSchoolViewModel(BuildContext ctx) {
    return IndividualSchoolViewModel(
      ctx,
      repository: serviceLocator.repository,
    );
  }

  DashboardsViewModel createDashboardsViewModel(
    BuildContext ctx,
    String schoolId,
    String districtCode,
  ) {
    return DashboardsViewModel(
      ctx,
      repository: serviceLocator.repository,
      schoolId: schoolId,
      districtCode: districtCode,
    );
  }
}
