import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';

class Strings {
  static Emis emis = Emis.fedemis;

  final Locale locale;

  Strings(this.locale);

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static Map<Emis, Map<String, Map<String, String>>> _stringsForEmis = {
    Emis.fedemis: _localizedValuesFedEmis,
    Emis.miemis: _localizedValuesMiEmis,
    Emis.kemis: _localizedValuesKiEmis,
  };

  /// This one should contain ALL stings, since it is used as fallback
  static Map<String, Map<String, String>> _localizedValuesDefault = {
    'en': {
      'appName': 'Pacific Open Education Data',
      'splash': '\nPACIFIC OPEN\n EDUCATION DATA',
      'notImplementedTitle': 'Construction',
      'notImplementedMessage': 'This section is under construction',
      'labelTotal': 'Total',
      'labelMale': 'Male',
      'labelFemale': 'Female',
      'labelNational': 'National',
      'labelNoData': 'No data',
      'labelEce': 'ECE',
      'labelPrimary': 'Primary',
      'labelSec': 'Secondary',
      'error_unknown': 'Unknown error occurred',
      'error_server_unavailable':
          'You are not connected to the Internet and there was no previously fetched data to display. Try again with a working Internet connection.',
      'miemisTitle': 'Marshall Islands',
      'fedemisTitle': 'Federated States of Micronesia',
      'fedemisTitleMultiline': 'Federated States \nof Micronesia',
      'kiemisTitle': 'Republic of Kiribati',
      'homeChangeCountryButton': 'Change country',
      'homeChangeCountryTitle': 'Change country',
      'homeSectionSchoolsDashboards': 'Schools',
      'homeSectionTeachersDashboards': 'Teachers',
      'homeSectionExamsDashboards': 'Exams',
      'homeSectionSchoolsAccreditationDashboards': 'School Accreditations',
      'homeSectionIndicators': 'Indicators',
      'homeSectionBudgets': 'Budgets',
      'homeSectionIndividualSchools': 'Individual Schools',
      'homeSectionSpecialEducation': 'Special Education',
      'homeSectionWash': 'Wash',
      'filtersTitle': 'Filter',
      'filtersByYear': 'Filter by year',
      'filtersByState': 'Filter by state',
      'filtersByAuthority': 'Filter by authority',
      'filtersByGovernment': 'Filter by government',
      'filtersByClassLevel': 'Filter by class level',
      'filtersByGovt': 'Filter by  Govt / Non-govt',
      'filtersBySchoolLevels': 'Filter by  Govt / Non-govt',
      'filtersDisplayAllStates': 'Display All States',
      'filtersDisplayAllAuthority': 'Display All Authority',
      'filtersDisplayAllGovernmentFilters': 'Display all Government filters',
      'filtersDisplayAllLevelFilters': 'Display all Level filters',
      'schoolsDashboardsTitle': 'Schools',
      'schoolsDashboardsMeasureEnroll': 'Schools Enrollment',
      'schoolsDashboardsEnrollByStateTitle': 'Schools Enrollment by State',
      'schoolsDashboardsEnrollByAuthorityTitle':
          'Schools Enrollment by Authority',
      'schoolsDashboardsEnrollByGovernmentTitle':
          'Schools Enrollment Govt / \nNon-govt',
      'schoolsDashboardsEnrollByAgeLevelGenderTitle':
          'Schools Enrollment by Age, Education \nLevel and Gender',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Schools Enrollment by School Levels, \nState and Gender',
      'schoolsDashboardsPrivacyDomain': 'Public/Private',
      'schoolsDashboardsStateDomain': 'State',
      'schoolsDashboardsAuthorityDomain': 'Authority',
      'schoolsDashboardsAgeDomain': 'Age',
      'schoolsDashboardsSchoolLevelDomain': 'School \nLevels',
      'teachersDashboardsTitle': 'Teachers',
      'teachersDashboardsEnrollByAuthorityTitle': 'Teachers by Authority',
      'teachersDashboardsEnrollByStateTitle': 'Teachers by State',
      'teachersDashboardsEnrollByLevelStateGenderTitle':
          'Teachers by School Levels, \nState and Gender',
      'teachersDashboardsEnrollByGovernmentTitle':
          'Teachers by Govt / \nNon-govt',
      'teachersDashboardsEnrollDomain': 'Teachers',
      'teachersDashboardsPrivacyDomain': 'Public/Private',
      'teachersDashboardsStateDomain': 'State',
      'teachersDashboardsAuthorityDomain': 'Authority',
      'teachersDashboardsSchoolLevelDomain': 'School \nLevels',
      'examsDashboardsTitle': 'Exams',
      'examsDashboardsFilterExam': 'Exam',
      'examsDashboardsFilterView': 'View',
      'examsDashboardsFilterStandard': 'Filter by standard',
      'examsDashboardsViewByBenchmarkAndGender': 'By Benchmarks and Gender',
      'examsDashboardsViewByStandardAndGender':
          'By Standards and Gender for Last 3 Years',
      'examsDashboardsViewByStandardAndState': 'By Standards and State',
      'schoolsAccreditationDashboardsTitle': 'School Accreditations',
      'schoolsAccreditationDashboardsProgressTitle': 'Accreditation Progress',
      'schoolsAccreditationDashboardsDistrictTitle': 'District Status',
      'schoolsAccreditationDashboardsStatusByStateTitle':
          'Accreditation Status by State',
      'schoolsAccreditationDashboardsPerformanceByStandardTitle':
          'Performance by Standard',
      'schoolsAccreditationDashboardsStateDomain': 'State',
      'schoolsAccreditationDashboardsStandardDomain': 'Standard',
      'schoolsListTitle': 'Individual Schools',
      'washListTitle': 'Wash',
      'schoolsListSearchHint': 'Search',
      'individualSchoolDashboardsTitle': 'DASHBOARDS',
      'individualSchoolExamsTitle': 'EXAMS',
      'individualSchoolDashboardEnrollTitle': 'Enrollment',
      'individualSchoolDashboardRatesTitle': 'Rates',
      'individualSchoolDashboardEnrollByGradeLevelGenderTitle':
          'By Grade Level and Gender',
      'individualSchoolDashboardEnrollByGradeLevelGenderHistoryTitle':
          'By Grade Level and Gender History',
      'individualSchoolDashboardEnrollByGenderHistoryTitle':
          'Enrollment by Gender History',
      'individualSchoolDashboardEnrollFemalePartTitle': 'Female Part',
      'individualSchoolDashboardEnrollByGradeLevelGenderChart': 'Chart',
      'individualSchoolDashboardEnrollByGradeLevelGenderTable': 'Table',
      'individualSchoolDashboardEnrollByGradeLevelGenderGrade': 'Grade',
      'individualSchoolDashboardEnrollByGradeLevelGenderHistoryStacked':
          'Stacked',
      'individualSchoolDashboardEnrollByGradeLevelGenderHistoryUnstacked':
          'Unstacked',
      'individualSchoolDashboardEnrollFemalePartDetailed': ' in details',
      'individualSchoolDashboardEnrollFemalePartHistory': 'Full History',
      'individualSchoolDashboardRatesDropoutTitle': 'Dropout Rate',
      'individualSchoolDashboardRatesPromoteTitle': 'Promote Rate',
      'individualSchoolDashboardRatesRepeatTitle': 'Repeat Rate',
      'individualSchoolDashboardRatesSurvivalTitle': 'Survival Rate',
      'individualSchoolDashboardRatesDetailed': ' in details',
      'individualSchoolDashboardRatesHistoryChart': 'History (chart)',
      'individualSchoolDashboardRatesHistoryTable': 'History (table)',
      'individualSchoolDashboardRatesHistoryTableDomain': 'GR',
      'individualSchoolExamsByBenchmarkTitle':
          'Achievement Results by Benchmark',
      'individualSchoolExamsByBenchmarkWellBelowLevel': 'Well below',
      'individualSchoolExamsByBenchmarkApproachingLevel': 'Approaching',
      'individualSchoolExamsByBenchmarkMinimallyLevel': 'Minimally',
      'individualSchoolExamsByBenchmarkCompetentLevel': 'Competent',
      'individualSchoolExamsByGenderTitle': 'Achievement by Gender',
      'individualSchoolExamsHistoryTitle': 'Achievement Table History',
      'individualSchoolExamsFilterYear': 'Exam Year',
      'individualSchoolExamsFilterType': 'Exam Type',
      'individualSchoolExamsHistoryYear': ' Exam Year',
      'individualSchoolExamsHistoryTableCode': 'Exam Code',
      'budgetsDashboardsTitle': 'Budgets',
      'budgetsEducationFinancing': 'Education Financing: Dashboard',
      'budgetsGnpAndGovernmentSpendingActualExpense':
          'GNP and Government Spending Actual Expense',
      'budgetsGnpAndGovernmentSpendingBudgetedExpense':
          'GNP and Government Spending Budgeted Expense',
      'budgetsGnpAndGovernmentSpending': 'GNP and Government Spending',
      'budgetsSpendingBySector': 'Spending By Sector',
      'budgetsSpendingByDistrict': 'Spending By District',
      'budgetsDashboardComponent': 'Dashboard Component',
      'year': 'Year',
      'govtExpense': 'Govt Expense',
      'govtExpenditure': 'Govt Expenditure',
      'edExpense': 'Ed Expense',
      'gNP': 'GNP',
      'edGovtPercentage': 'Ed/Govt %',
      'edGNPPercentage': 'Ed/GNP %',
      'eCE': 'ECE',
      'primaryEducation': 'Primary Education',
      'secondaryEducation': 'Secondary Education',
      'actualExpenditure': 'Actual Expenditure',
      'budgetExpenditure': 'Budget Expenditure',
      'budget': 'Budget',
      'actualRecurrentExpenditure': 'Actual Recurrent Expenditure',
      'budgetRecurrentExpenditure': 'Budget Recurrent Expenditure',
      'actualExpPerHead': 'Actual Exp per Head',
      'budgetExpPerHead': 'Budget Exp per Head',
      'enrolment': 'Enrollment',
      'enrollment': 'Enrollment',
      //Special Education
      'specialEducationTitle': 'Special Education: Dashboard',
      'disability': 'Disability',
      'ethnicity': 'Ethnicity',
      'specialEducationEnvironment': 'Special Education Environment',
      'englishLearnerStatus': 'English Learner Status',
      'cohortDistribution': 'Cohort Distribution',
      'byState': 'By State',
      'byYear': 'By Year',
      'schedule': 'Schedule',
      'diagram': 'Diagram',
      'environment': 'Environment',
      'englishLearner': 'English Learner',
      'district': 'District',
      'districtTotals': 'District Totals',
      'toilets': 'Toilets',
      'waterSources': 'Water Sources',
      'washDashboardsTitle': 'Reviews And Inspections: Dashboard',
      'washCumulative': 'Cumulative',
      'washEvaluated': 'Evaluated',
      'wastToiletsTotal': 'Toilets (Total)',
      'washUsableToilets': 'UsableToilets',
      'washUsablePercentage': '% Usable',
      'washPupilsToilets': '% Usable (gender)',
      'washPupilsToilet': 'Pupils / toilet',
      'washUsedForDrinking': 'Used for Drinking',
      'washCurrentlyAvailable': 'Currently Available',
      'washSchNo': 'SchNo',
      'numbers': 'Numbers'
    },
  };

  // region Specific strings
  static Map<String, Map<String, String>> _localizedValuesFedEmis = {
    'en': {},
  };

  static Map<String, Map<String, String>> _localizedValuesMiEmis = {
    'en': {
      'schoolsDashboardsEnrollByStateTitle':
          'Schools Enrollment by Atolls and Islands',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Schools Enrollment by School Levels, \nAtolls and Islands and Gender',
      'schoolsDashboardsStateDomain': 'Atolls and Islands',
      'filtersDisplayAllStates': 'Display All Atolls and Islands',
      'filtersByState': 'Filter by atolls and islands',
      'teachersDashboardsEnrollByStateTitle': 'Teachers by Atolls and Islands',
      'teachersDashboardsStateDomain': 'Atolls and Islands',
      'teachersDashboardsEnrollByLevelStateGenderTitle':
          'Teachers by School Levels, \nAtolls and Islands and Gender',
      'examsDashboardsViewByStandardAndState':
          'By Standards and Atolls and Islands',
      'schoolsAccreditationDashboardsStatusByStateTitle':
          'Accreditation Status by Atolls and Islands',
      'schoolsAccreditationDashboardsStateDomain': 'Atolls and Islands',
    },
  };

  static Map<String, Map<String, String>> _localizedValuesKiEmis = {
    'en': {
      'homeSectionExamsDashboards': 'National Tests',
      'filtersDisplayAllStates': 'Display All Districts',
      'filtersByState': 'Filter by District',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Schools Enrollment by School Levels, \nDistrict and Gender',
      'schoolsDashboardsEnrollByStateTitle': 'Schools Enrollment by District',
      'schoolsDashboardsStateDomain': 'District',
      'teachersDashboardsEnrollByLevelStateGenderTitle':
          'Teachers by School Levels, \nDistrict and Gender',
      'teachersDashboardsStateDomain': 'District',
      'teachersDashboardsEnrollByStateTitle': 'Teachers by District',
      'examsDashboardsTitle': 'National Tests',
      'examsDashboardsViewByBenchmarkAndGender': 'By Outcomes and Gender',
      'examsDashboardsViewByStandardAndGender':
          'By Tests and Gender for Last 3 Years',
      'examsDashboardsViewByStandardAndState': 'By Tests and State',
      'examsDashboardsFilterStandard': 'Filter by Test',
      'schoolsAccreditationDashboardsStatusByStateTitle':
          'Accreditation Status by District',
      'schoolsAccreditationDashboardsPerformanceByStandardTitle':
          'Performance by Test',
      'schoolsAccreditationDashboardsStateDomain': 'District',
      'schoolsAccreditationDashboardsStandardDomain': 'Test',
    },
  };
  // endregion

  String _getLocalizedValue(String code) {
    final emisStrings = _stringsForEmis[emis];
    String translation = emisStrings[locale.languageCode][code];

    // fallback to 'en' locale in same Emis
    if (translation == null) {
      translation = emisStrings['en'][code];
    }

    // fallback to default translations
    if (translation == null) {
      translation = _localizedValuesDefault[locale.languageCode][code];
    }

    // fallback to 'en' locale in default translations
    if (translation == null) {
      translation = _localizedValuesDefault['en'][code];
    }

    return translation;
  }
}

class StringsDelegate extends LocalizationsDelegate<Strings> {
  const StringsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) {
    return SynchronousFuture<Strings>(Strings(locale));
  }

  @override
  bool shouldReload(StringsDelegate old) => false;
}

extension StringLocaleExt on String {
  String localized(BuildContext context) {
    if (this == null) {
      return this;
    }
    return Strings.of(context)._getLocalizedValue(this) ?? this;
  }
}
