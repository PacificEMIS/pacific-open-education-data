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
      'labelNoDataWithFilters': 'No data',
      'labelNa': 'n/a',
      'na': 'n/a', // translating server responce
      'errorTitle': 'Error',
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
      'filtersByYear': 'Selected Year',
      'filtersByState': 'Selected State',
      'filtersByAuthority': 'Selected Authority',
      'filtersByGovernment': 'Selected Govt / Non-govt',
      'filtersByClassLevel': 'Selected School Levels',
      'filtersByGovt': 'Selected  Govt / Non-govt',
      'filtersBySchoolLevels': 'Selected  School Levels',
      'filtersDisplayAllStates': 'Display All States',
      'filtersDisplayAllAuthority': 'Display All Authority',
      'filtersDisplayAllGovernmentFilters': 'Display all Government filters',
      'filtersDisplayAllLevelFilters': 'Display all Level filters',
      'schoolsDashboardsTitle': 'Schools',
      'schoolsDashboardsMeasureEnroll': 'Total',
      'schoolsDashboardsEnrollByStateTitle': 'Enrollment by State',
      'schoolsDashboardsEnrollByAuthorityTitle': 'Enrollment by Authority',
      'schoolsDashboardsEnrollByGovernmentTitle':
          'Enrollment Govt / \nNon-govt',
      'schoolsDashboardsEnrollByAgeLevelGenderTitle':
          'Enrollment by Age, Education \nLevel and Gender',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Enrollment by School Levels, \nState and Gender',
      'schoolsDashboardsPrivacyDomain': 'Public/Private',
      'schoolsDashboardsStateDomain': 'State',
      'schoolsDashboardsAuthorityDomain': 'Authority',
      'schoolsDashboardsAgeDomain': 'Age',
      'schoolsDashboardsSchoolLevelDomain': 'School \nLevels',
      'teachersDashboardsTitle': 'Teachers',
      'teachersDashboardsChartTitle': 'Teachers (Number of)',
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
      'examsDashboardsFilterStandard': 'Selected standard',
      'examsDashboardsViewByBenchmarkAndGender': 'By Benchmarks and Gender',
      'examsDashboardsViewByStandardAndGender':
          'By Standards and Gender for Last 3 Years',
      'examsDashboardsViewByStandardAndState': 'By Standards and State',
      'schoolsAccreditationDashboardsTitle': 'School Accreditations',
      'schoolsAccreditationDashboardsProgressTitle':
          'Accreditation Progress by Year',
      'schoolsAccreditationDashboardsProgressByStateTitle':
          'Accreditation Progress by State',
      'schoolsAccreditationDashboardsProgressNationalTitle':
          'Accreditation Progress National',
      'schoolsAccreditationDashboardsDistrictTitle': 'State Status',
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
      'individualSchoolAccreditationTitle': 'ACCREDITATION',
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
      'individualSchoolAccreditationsSE1': 'SE.1 Leadership',
      'individualSchoolAccreditationsSE2': 'SE.2 Teacher Performance',
      'individualSchoolAccreditationsSE3': 'SE.3 Data management',
      'individualSchoolAccreditationsSE4': 'SE.4 NCSB',
      'individualSchoolAccreditationsSE5': 'SE.5 Facilities',
      'individualSchoolAccreditationsSE6': 'SE.6 SIP',
      'individualSchoolAccreditationsCriteria1Short': 'C1',
      'individualSchoolAccreditationsCriteria2Short': 'C2',
      'individualSchoolAccreditationsCriteria3Short': 'C3',
      'individualSchoolAccreditationsCriteria4Short': 'C4',
      'individualSchoolAccreditationsCriteria1': 'Criteria 1',
      'individualSchoolAccreditationsCriteria2': 'Criteria 2',
      'individualSchoolAccreditationsCriteria3': 'Criteria 3',
      'individualSchoolAccreditationsCriteria4': 'Criteria 4',
      'individualSchoolAccreditationsResult': 'Result',
      'individualSchoolAccreditationsStandard': 'Standard',
      'individualSchoolAccreditationsCO': 'Classroom Observation',
      'individualSchoolAccreditationsInspectedBy': 'Inspected by: ',
      'individualSchoolAccreditationsDisclaimer': 'Only a summary of the FORM B'
          ' school accreditation results will be shown to the schools for '
          'information purposes. The actual data collection is done through an '
          'Android app not by the schools themselves but by designated '
          'inspectors. If you believe some of the results below are not correct'
          ' you must contact the National Data Management Office.',
      'budgetsDashboardsTitle': 'Budgets',
      'budgetsEducationFinancing': 'Education Financing : Dashboard',
      'budgetsGnpAndGovernmentSpendingActualExpense':
          'GNI (aka. GNP) and Government Spending Actual Expense',
      'budgetsGnpAndGovernmentSpendingBudgetedExpense':
          'GNI (aka. GNP) and Government Spending Budgeted Expense',
      'budgetsGnpAndGovernmentSpending':
          'GNI (aka. GNP) and Government Spending',
      'budgetsSpendingBySector': 'Spending By Sector',
      'budgetsSpendingByDistrict': 'Spending By States',
      'budgetsDashboardComponent': 'Dashboard Component',
      'budgetsGovtExpenditure': 'Govt Expenditure',
      'budgetsEce': 'ECE',
      'budgetsYearColumn': 'Year',
      'budgetsGnpColumn': 'GNI',
      'budgetsEdExpenseColumn': 'Ed Expense',
      'budgetsEdGNPPercentageColumn': 'Ed/GNI %',
      'budgetsGovtExpenseColumn': 'Govt Expense',
      'budgetsEdGovtPercentageColumn': 'Ed/Govt %',
      'budgetsPrimaryEducation': 'Primary Education',
      'budgetsSecondaryEducation': 'Secondary Education',
      'budgetsActualExpenditureTab': 'Actual Expenditure',
      'budgetsBudgetTab': 'Budget',
      'budgetsActualRecurrentExpenditureTab': 'Actual Recurrent Expenditure',
      'budgetsBudgetedRecurrentExpenditureTab': 'Budgeted Recurrent Expenditure',
      'budgetsActualExpPerHeadTab': 'Actual Exp per Head',
      'budgetsEnrollmentTab': 'Enrollment',
      'budgetsBudgetExpPerHeadTab': 'Budget Exp per Head',
      'budgetsSectorsDomain': 'Sectors',
      'budgetsStatesDomain': 'State',
      'budgetExpenditure': 'Budgeted Expenditure',
      'budgetsDistrictColumn': 'State',
      'budgetsActualColumn': 'Actual',
      'budgetsBudgetedColumn': 'Budgeted',
      //Special Education
      'specialEducationTitle': 'Special Education: Dashboard',
      'specialEducationTitleDisability': 'Disability',
      'specialEducationTitleEthnicity': 'Ethnicity',
      'specialEducationTitleEnvironment': 'Special Education Environment',
      'specialEducationTitleEnglishLearnerStatus': 'English Learner Status',
      'specialEducationTitleCohortDistribution': 'Cohort Distribution',
      'specialEducationTitleByState': 'By State',
      'specialEducationTitleByYear': 'By Year',
      'specialEducationTabNameEnvironment': 'Environment',
      'specialEducationTabNameDisability': 'Disability',
      'specialEducationTabNameEthnicity': 'Ethnicity',
      'specialEducationTabNameEnglishLearner': 'English Learner',
      'specialEducationTabNameSchedule': 'Bar chart',
      'specialEducationTabNameDiagram': 'Pie chart',
      'specialEducationAuthorityDomain': 'Authority',
      'specialEducationEnrollDomain': 'Enrollment',
      'washToiletsTitle': 'Toilets',
      'washWaterSourcesTitle': 'Water Sources',
      'washDashboardsTitle': 'Reviews And Inspections: Dashboard',
      'washCumulative': 'Cumulative',
      'washEvaluated': 'Evaluated',
      'washToiletsTotalToiletsTab': 'Toilets (Total)',
      'washToiletsUsableToiletsTab': 'Usable',
      'washToiletsUsablePercentTab': '% Usable',
      'washToiletsUsablePercentByGenderTab': '% Usable (gender)',
      'washToiletsPupilsByToiletTab': 'Pupils / toilet',
      'washToiletsPupilsByToiletByGenderTab': 'Pupils / toilet (gender)',
      'washToiletsPupilsByUsableToiletTab': 'Pupils / usable toilet',
      'washToiletsPupilsByUsableToiletByGenderTab': 'Pupils / usable toilet (gender)',
      'washToiletsPupilsTab': 'Pupils',
      'washToiletsPupilsMirroredTab': 'Pupils (mirror format)',
      'washToiletsCommonLabel': 'Common',
      'washToiletsBoysLabel': 'Boys',
      'washToiletsGirlsLabel': 'Girls',
      'washToiletsPupilsLabel': 'Pupils',
      'washToiletsUsablePercentLabel': 'Usable %',
      'washWaterCurrentlyAvailableTab': 'Currently Available',
      'washWaterUsedForDrinkingTab': 'Used for Drinking',
      'washWaterLegendPipedWaterSupply': 'Piped Water Supply',
      'washWaterLegendProtectedWell': 'Protected Well',
      'washWaterLegendUnprotectedWellSpring': 'Unprotected Well Spring',
      'washWaterLegendRainwater': 'Rainwater',
      'washWaterLegendBottledWater': 'Bottled Water',
      'washWaterLegendTanker': 'Tanker/Truck or Cart',
      'washWaterLegendSurfacedWater': 'Surfaced Water (Lake, River, Stream)',
      'washDistrictTotalsTitle': 'Question Totals by State',
      'washDistrictTotalsQuestionSelectorTitle': 'Question',
      'washDistrictTotalsNoQuestionSelectedLabel': 'No question selected',
      'washDistrictTotalsAccumulatedTab': 'Cumulative to ',
      'washDistrictTotalsEvaluatedTab': 'Evaluated in ',
      'washSchNo': 'SchNo',
      'numbers': 'Numbers',
      'schoolsEnrollment': 'Enrollment',
      'schoolsByState': 'By State',
      'schoolsByAuthority': 'By Authority',
      'schoolsByGovtNonGovt': 'By Govt / Non-govt',
      'schoolsCertifiedQualified': 'Certified and Qualified ',
      'schoolAccreditationCumulative': 'Cumulative to',
      'schoolAccreditationEvaluated': 'Evaluated in',
      'levels': 'Levels',
      'sectors': 'Sectors',
      'certifiedAndQualified': 'Certified and Qualified ',
      'all': 'Total',
      'qualified': 'Qualified',
      'certified': 'Certified',
      'qualifiedAndCertified':'Qualified and Certified',
      'qualifiedNotCertified':'Qualified (not certified)',
      'other': 'Other',
      'downloadCurrentCountry': 'Download this country data for offline use',
      'downloadTitle': 'Download data',
      'downloadCancel': 'Cancel',
      'downloadNote': 'There is a large amount of data to download. To make sure all data should be downloaded, press Download, keep your phone with screen on and stay at this page until download completes. This could take several minutes to complete even on a good Internet connection.',
      'downloadSubtitle1': 'Download',
      'downloadSubtitle2': 'data for offline use',
      'downloadIndSchools': 'Download Individual schools',
      'downloadAction': 'DOWNLOAD',
      'downloadDone': 'DONE',
      'downloadFailedToLoad': 'Files did not load',
      'downloadReload': 'Reload',
      'downloadSubjectLookups': 'Global lookups',
      'downloadSubjectSchools': 'Schools section',
      'downloadSubjectTeachers': 'Teachers section',
      'downloadSubjectExams': 'Exams section',
      'downloadSubjectSA': 'School Accreditation section',
      'downloadSubjectBudgets': 'Budgets section',
      'downloadSubjectSpecialEducation': 'Special Education section',
      'downloadSubjectWASH': 'WASH section',
      'downloadSubjectIndicators': 'Indicators section',
      'downloadSubjectIndividualSchoolsList': 'Individual Schools list',
      'downloadSubjectIndividualSchoolsDetailed': 'Individual Schools info for school',
    },
  };

  // region Specific strings
  static Map<String, Map<String, String>> _localizedValuesFedEmis = {
    'en': {},
  };

  static Map<String, Map<String, String>> _localizedValuesMiEmis = {
    'en': {
      'schoolsDashboardsEnrollByStateTitle': 'Enrollment by Atolls and Islands',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Enrollment by School Levels, \nAtolls and Islands and Gender',
      'schoolsDashboardsStateDomain': 'Atolls and Islands',
      'filtersDisplayAllStates': 'Display All Atolls and Islands',
      'teachersDashboardsEnrollByStateTitle': 'Teachers by Atolls and Islands',
      'teachersDashboardsStateDomain': 'Atolls and Islands',
      'teachersDashboardsEnrollByLevelStateGenderTitle':
          'Teachers by School Levels, \nAtolls and Islands and Gender',
      'examsDashboardsViewByStandardAndState':
          'By Standards and Atolls and Islands',
      'schoolsAccreditationDashboardsStatusByStateTitle':
          'Accreditation Status by Atolls and Islands',
      'schoolsAccreditationDashboardsStateDomain': 'Atolls and Islands',
      'schoolsByState': 'By Atoll / Islands',
      'schoolsByAuthority': 'By Authority',
      'schoolsByGovtNonGovt': 'By School Type',
      'schoolsCertifiedQualified': 'Certified and Qualified ',
      'filtersTitle': 'Filter',
      'filtersByYear': 'Selected Year',
      'filtersByState': 'Selected Atolls / Islands',
      'filtersByAuthority': 'Selected Authority',
      'filtersByGovernment': 'Selected School Type',
      'filtersByClassLevel': 'Selected School Levels',
      'filtersByGovt': 'Selected  School Type',
      'filtersBySchoolLevels': 'Selected  School Type',
      'filtersDisplayAllAuthority': 'Display All Authority',
      'filtersDisplayAllGovernmentFilters': 'Display all Government filters',
      'filtersDisplayAllLevelFilters': 'Display all Level filters',
      'schoolsAccreditationDashboardsProgressByStateTitle': 'Accreditation Progress by Atoll / Island ',
      'schoolsAccreditationDashboardsDistrictTitle': 'Atoll / Island Status',
      'budgetsSpendingByDistrict': 'Spending by Atolls and Islands',
      'budgetsStatesDomain': 'Atolls and Islands',
      'budgetsDistrictColumn': 'Atoll / Island',
      'washDistrictTotalsTitle': 'Question Totals by Atolls and Islands',
      'specialEducationTitleByState': 'By Atoll / Islands',
    },
  };

  static Map<String, Map<String, String>> _localizedValuesKiEmis = {
    'en': {
      'homeSectionExamsDashboards': 'National Tests',
      'filtersDisplayAllStates': 'Display All Districts',
      'filtersByState': 'Selected District',
      'schoolsDashboardsEnrollByLevelStateGenderTitle':
          'Enrollment by Age, \nEducation Level and Gender',
      'schoolsDashboardsEnrollByStateTitle': 'Enrollment by District ',
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
      'examsDashboardsFilterStandard': 'Selected Test',
      'schoolsAccreditationDashboardsStatusByStateTitle':
          'Accreditation Status by District',
      'schoolsAccreditationDashboardsPerformanceByStandardTitle':
          'Performance by Test',
      'schoolsAccreditationDashboardsStateDomain': 'District',
      'schoolsAccreditationDashboardsStandardDomain': 'Test',
      'schoolsAccreditationDashboardsDistrictTitle': 'District Status',
      'schoolsDashboardsEnrollByAuthorityTitle': 'Enrollment by Authority',
      'schoolsDashboardsEnrollByGovernmentTitle': 'Enrollment by School Type',
      'schoolsDashboardsEnrollByAgeLevelGenderTitle':
          'Enrollment by Age, Education \nLevel and Gender',
      'budgetsStatesDomain': 'Districts',
      'budgetsDistrictColumn': 'District',
      'washDistrictTotalsTitle': 'Question Totals by District',
      'specialEducationTitleByState': 'By District',
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
