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

  String _firstYear = "";
  String _secondYear = "";

  List<int> get years => getYears()
      .map((e) => int.parse(e))
      .toList()
      .chainSort((lv, rv) => rv.compareTo(lv));

  final List<String> _educationLevelIds;
  final List<String> educationLevelNames;
  final List<String> _regions;
  final List<String> regionsNames;
  final Indicators _indicators;

  List<String> _filteredEducationLevelIds = [];

  IndicatorsNavigator(IndicatorsContainer indicators, Lookups lookups,
      {IndicatorsNavigator oldNavigator})
      : _educationLevelIds = indicators.indicators.enrolments.enrolments
            .uniques((it) => it.educationLevelCode),
        educationLevelNames = indicators.indicators.enrolments.enrolments
            .uniques(
                (it) => it.educationLevelCode.from(lookups.educationLevels)),
        _indicators = indicators.indicators,
        _regions = lookups.districts.map((it) => it.code).toList(),
        regionsNames = lookups.districts.map((it) => it.name).toList() {
    if (oldNavigator != null) {
      _firstYear = oldNavigator._firstYear;
      _secondYear = oldNavigator._secondYear;
      _selectedEducationLevelId = oldNavigator._selectedEducationLevelId;
      _selectedRegionId = oldNavigator._selectedRegionId;
    }
    _educationLevelIds.forEach((it) {
      if (it == 'ECE' || it == 'PRI' || it == 'SEC')
        _filteredEducationLevelIds.add(it);
    });

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
      _selectedEducationLevelId = _filteredEducationLevelIds.length - 1;
    }
    if (_selectedEducationLevelId > _filteredEducationLevelIds.length - 1) {
      _selectedEducationLevelId = 0;
    }
  }

  String get educationLevelName {
    if (educationLevelNames == null ||
        _selectedEducationLevelId >= educationLevelNames.length) {
      return "";
    }
    return _filteredEducationLevelIds[_selectedEducationLevelId];
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
    return _filteredEducationLevelIds[_selectedEducationLevelId];
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
    final indicatorsEnrolmentByLevel =
        _indicators.getEnrolment(year, selectedEducationCode);
    final indicatorsEnrolmentYear =
        _indicators.getEnrolmentLastYear(year, indicatorsEnrolmentByLevel);
    final survival = _indicators.getSurvivalLastYear(year, indicatorsEnrolmentByLevel);
    final indicatorsSchoolCount =
        _indicators.getSchoolCount(year, indicatorsEnrolmentByLevel, lookups);

    return new Indicator(
        enrolment: indicatorsEnrolmentByLevel,
        schoolCount: indicatorsSchoolCount,
        enrolmentLastGrade: indicatorsEnrolmentYear,
        allGradesCurrentYear: _indicators.getEnrolmentAllGradesInYear(year.toString()),
        previous: years.last >= int.tryParse(year)
            ? null
            : getIndicatorForYear((int.tryParse(year) - 1).toString(), lookups),
        //sector: _indicators.getSector(indicatorsEnrolmentByLevel)
        survival: survival,
        teacherELevel: _indicators.getTeacherELevel(indicatorsEnrolmentByLevel));
  }

  List<Indicator> getAllIndicatorsData(Lookups lookups, int year, int endYear) {
    List<Indicator> indicators = [];

    for (year; year <= endYear; year++) {
      final indicatorsEnrolmentByLevel =
          _indicators.getEnrolment(year.toString(), selectedEducationCode);
      final indicatorsEnrolmentYear = _indicators.getEnrolmentLastYear(
          year.toString(), indicatorsEnrolmentByLevel);
      final indicatorsSchoolCount = _indicators.getSchoolCount(
          year.toString(), indicatorsEnrolmentByLevel, lookups);
      final survival = _indicators.getSurvivalLastYear(year.toString(), indicatorsEnrolmentByLevel);

      var indicator = new Indicator(
          enrolment: indicatorsEnrolmentByLevel,
          schoolCount: indicatorsSchoolCount,
          enrolmentLastGrade: indicatorsEnrolmentYear,
          previous:
              indicators.length > 0 ? indicators[indicators.length - 1] : null,
          //sector: _indicators.getSector(indicatorsEnrolmentByLevel),
          teacherELevel: _indicators.getTeacherELevel(indicatorsEnrolmentByLevel),
          survival: survival,
          allGradesCurrentYear: _indicators.getEnrolmentAllGradesInYear(year.toString()));
      indicators.add(indicator);
    }
    return indicators;
  }

  void onYearFiltersChanged(Pair<String, String> years) {
    _firstYear = years.first;
    _secondYear = years.second;
  }

  void onRegionChanged(int regionId) {
    _selectedRegionId = regionId;
  }

  Pair<Indicator, Indicator> getIndicatorResults(Lookups lookups) {
    print('getIndicatorResults');
    return new Pair(
        getIndicatorForYear(_firstYear, lookups),
        _firstYear != _secondYear
            ? getIndicatorForYear(_secondYear, lookups)
            : new Indicator(
                enrolment: new IndicatorsEnrolmentByLevel(
                    year: "", educationLevelCode: selectedEducationCode),
                allGradesCurrentYear: [],
                schoolCount: new IndicatorsSchoolCount(year: "", count: null),
                enrolmentLastGrade: null,
                previous: null,
                survival: null,
                //sector: null,
                teacherELevel: null));
  }

  List<Indicator> getIndicatorsResults(
      Lookups lookups, int firstYear, int secondYear) {
    return getAllIndicatorsData(lookups, firstYear, secondYear);
  }
}
