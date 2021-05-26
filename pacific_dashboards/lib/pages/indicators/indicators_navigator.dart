import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/indicators/indicator.dart';
import 'package:pacific_dashboards/models/indicators/indicators.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';
import 'package:pacific_dashboards/models/indicators/indicators_school_count.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

class IndicatorsNavigator {
  static const String kNoTitleKey = "";
  int _selectedEducationLevelId = 0;
  int _selectedRegionId = 0;

  String _firstYear = "2014";
  String _secondYear = "2015";


  final List<String> _educationLevelIds;
  final List<String> educationLevelNames;
  final List<String> _regions;
  final List<String> regionsNames;
  final Indicators _indicators;

  IndicatorsNavigator(
      IndicatorsContainer indicators,
      Lookups lookups,
      {IndicatorsNavigator oldNavigator})
      : _educationLevelIds = indicators.indicators.enrolments.enrolments
      .uniques((it) => it.educationLevelCode),
        educationLevelNames = indicators.indicators.enrolments.enrolments
            .uniques((it) =>
            it.educationLevelCode.from(lookups.educationLevels)),
        _indicators = indicators.indicators,
        _regions = lookups.districts.map((it) => it.code).toList(),
        regionsNames = lookups.districts.map((it) => it.name).toList() {
    if (oldNavigator != null) {
      _firstYear = oldNavigator._firstYear;
      _secondYear = oldNavigator._secondYear;
      _selectedEducationLevelId = oldNavigator._selectedEducationLevelId;
      _selectedRegionId = oldNavigator._selectedRegionId;
    }
    _regions.insert(0, "");
    regionsNames.insert(0, "ALL");
    _changeEducationLevelPage();
  }

  void nextEducationLevelPage() {
    _selectedEducationLevelId++;
    _changeEducationLevelPage();
  }

  void prevEducationLevelPage() {
    _selectedEducationLevelId--;
    _changeEducationLevelPage();
  }

  void _changeEducationLevelPage() {
    if (_selectedEducationLevelId < 0) {
      _selectedEducationLevelId = _educationLevelIds.length - 1;
    }
    if (_selectedEducationLevelId > _educationLevelIds.length - 1) {
      _selectedEducationLevelId = 0;
    }
  }

  String get educationLevelName {
    if (educationLevelNames == null ||
        _selectedEducationLevelId >= educationLevelNames.length) {
      return "";
    }
    return educationLevelNames[_selectedEducationLevelId];
  }

  String get pageName {
    return educationLevelName + " Education Indicators";
  }

  String get selectedFirstYear {
    return _firstYear;
  }

  String get selectedSecondYear {
    return _secondYear;
  }

  String get selectedEducationCode {
    if (educationLevelNames == null ||
        _selectedEducationLevelId >= educationLevelNames.length) {
      return "";
    }
    return _educationLevelIds[_selectedEducationLevelId];
  }

  String get regionId {
    if (_regions == null || _selectedRegionId >= _regions.length) {
      return "";
    }
    return _regions[_selectedRegionId];
  }

  String get regionName {
    if (_regions == null || _selectedRegionId >= _regions.length) {
      return "";
    }
    return regionsNames[_selectedRegionId];
  }

  List<String> getYears() {
    return _indicators.enrolments.enrolments.uniques((it) => it.year);
  }

  Indicator getIndicatorForYear(String year, Lookups lookups) {
    IndicatorsEnrolmentByLevel indicatorsEnrolmentByLevel;
    var foundEnrolments = false;
    _indicators.enrolments.enrolments.forEach((element) {
      if (element.year == year &&
          element.educationLevelCode == selectedEducationCode) {
        foundEnrolments = true;
        indicatorsEnrolmentByLevel = element;
      }
    });
    if (!foundEnrolments)
      indicatorsEnrolmentByLevel = new IndicatorsEnrolmentByLevel(
          year: year, educationLevelCode: selectedEducationCode);

    var schoolTypesOfLevel = lookups.schoolTypeLevels.expand((e) =>
    [
      if (indicatorsEnrolmentByLevel.isSchoolOfLevel(e.yearOfEducation)) e
          .schoolCode
    ]).uniques((it) => it);

    var schoolCount = 0;
    _indicators.schoolCounts.schoolCounts.forEach((element) {
      if (element.year == year &&
          schoolTypesOfLevel.contains(element.schoolType)) {
        schoolCount += element.count;
      }
    });

    IndicatorsSchoolCount indicatorsSchoolCount = new IndicatorsSchoolCount(
        year: year, count: schoolCount);

    var indicator = new Indicator(enrolment: indicatorsEnrolmentByLevel,
        schoolCount: indicatorsSchoolCount);
    return indicator;
  }

  void onYearFiltersChanged(Pair<String, String> years) {
    _firstYear = years.first;
    _secondYear = years.second;
  }


  void onRegionChanged(int regionId) {
    _selectedRegionId = regionId;
  }

  Pair<Indicator, Indicator> getIndicatorResults(Lookups lookups) {
    return new Pair(
        getIndicatorForYear(_firstYear, lookups),
        _firstYear != _secondYear
            ? getIndicatorForYear(_secondYear, lookups)
            : new Indicator(enrolment: new IndicatorsEnrolmentByLevel(
            year: "", educationLevelCode: selectedEducationCode),
            schoolCount: new IndicatorsSchoolCount(
                year: "", count: null)));
  }
}
