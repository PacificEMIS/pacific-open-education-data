import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

import '../../models/exam/exam_separated.dart';

class ExamsNavigator {
  static const String kNoTitleKey = "";
  int _selectedExamPageId = 0;
  int _selectedExamViewId = 0;
  int _selectedExamRecordTypeId = 0;
  int _selectedExamCountModeId = 0;
  int _selectedExamGovTypeId = 0;
  int _selectedAuthorityId = -1;
  int _selectedYearId = 0;

  final List<String> _examPageNames;
  final List<String> _authorityNames;
  final List<String> _examViews = [
    'examsDashboardsViewByBenchmarkAndGender',
    'examsDashboardsViewByStandardAndGender',
    'examsDashboardsViewByStandardAndState',
  ];
  final List<String> _examRecordType = [
    'Exam',
    'Standard',
    'Benchmark',
    'Indicator',
  ];
  final List<String> _examCountMode = [
    'examShowMode1',
    'examShowMode2',
    'examShowMode3',
  ];
  final List<String> _examGovType = [
    'All',
    'govt',
    'nonGovt',
  ];
  final List<ExamSeparated> _exams;

  final List<int> _years;

  ExamsNavigator(List<ExamSeparated> exams)
      : _examPageNames = exams.uniques((it) => it.name),
        _authorityNames = exams.where((e) => e.authorityCode != '')
            .uniques((it) => it.authorityCode),
        _years = exams.where((e) => e.year != '')
            .uniques((it) => it.year).toList().chainSort((lv, rv) => rv.compareTo(lv)),
        _exams = exams {
    _changeExamPage();
  }

  void nextExamPage() {
    _selectedExamPageId++;
    _changeExamPage();
  }

  void prevExamPage() {
    _selectedExamPageId--;
    _changeExamPage();
  }

  void _changeExamPage() {
    if (_selectedExamPageId < 0) {
      _selectedExamPageId = _examPageNames.length - 1;
    }
    if (_selectedExamPageId > _examPageNames.length - 1) {
      _selectedExamPageId = 0;
    }
  }
//TODO Refactoring
  void nextExamView() {
    _selectedExamViewId++;
    _changeExamView();
  }

  void prevExamView() {
    _selectedExamViewId--;
    _changeExamView();
  }

  void nextExamRecordType() {
    _selectedExamRecordTypeId++;
    _changeExamRecordType();
  }

  void prevExamRecordType() {
    _selectedExamRecordTypeId--;
    _changeExamRecordType();
  }

  void nextExamCountMode() {
    _selectedExamCountModeId++;
    _changeExamCountMode();
  }

  void prevExamCountMode() {
    _selectedExamCountModeId--;
    _changeExamCountMode();
  }

  void nextExamGovType() {
    _selectedExamGovTypeId++;
    _changeExamGovType();
  }

  void prevExamGovType() {
    _selectedExamGovTypeId--;
    _changeExamGovType();
  }

  void nextExamAuthority() {
    _selectedAuthorityId++;
    _changeAuthority();
  }

  void prevExamAuthority() {
    _selectedAuthorityId--;
    _changeAuthority();
  }


  void nextExamYear() {
    _selectedYearId++;
    if (_selectedYearId >= _years.length)
      _selectedYearId = _years.length - 1;

    _changeAuthority();
  }

  void prevExamYear() {
    _selectedYearId--;
    if (_selectedYearId < 0)
      _selectedYearId = 0;

    _changeAuthority();
  }

  void _changeExamView() {
    if (_selectedExamViewId < 0) {
      _selectedExamViewId = _examViews.length - 1;
    }
    if (_selectedExamViewId > _examViews.length - 1) {
      _selectedExamViewId = 0;
    }
  }

  void _changeExamRecordType() {
    if (_selectedExamRecordTypeId < 0) {
      _selectedExamRecordTypeId = _examRecordType.length - 1;
    }
    if (_selectedExamRecordTypeId > _examRecordType.length - 1) {
      _selectedExamRecordTypeId = 0;
    }
  }

  void _changeExamCountMode() {
    if (_selectedExamCountModeId < 0) {
      _selectedExamCountModeId = _examCountMode.length - 1;
    }
    if (_selectedExamCountModeId > _examCountMode.length - 1) {
      _selectedExamCountModeId = 0;
    }
  }

  void _changeExamGovType() {
    if (_selectedExamGovTypeId < 0) {
      _selectedExamGovTypeId = _examGovType.length - 1;
    }
    if (_selectedExamGovTypeId > _examGovType.length - 1) {
      _selectedExamGovTypeId = 0;
    }
  }

  void _changeAuthority() {
    if (_selectedAuthorityId < -1) {
      _selectedAuthorityId = _authorityNames.length - 1;
    }
    if (_selectedAuthorityId > _authorityNames.length - 1) {
      _selectedAuthorityId = -1;
    }
  }

  String get pageName {
    if (_examPageNames == null ||
        _selectedExamPageId >= _examPageNames.length) {
      return "";
    }
    return _examPageNames[_selectedExamPageId];
  }

  String get authorityName {
    if (_authorityNames == null || _selectedAuthorityId < 0 ||
        _selectedAuthorityId >= _authorityNames.length) {
      return "All";
    }
    return _authorityNames[_selectedAuthorityId];
  }

  String get viewName {
    if (_examViews == null || _selectedExamViewId >= _examViews.length) {
      return "";
    }
    return _examViews[_selectedExamViewId];
  }

  int get showModeId => _selectedExamCountModeId;

  String get recordTypeName {
    if (_examRecordType == null ||
        _selectedExamRecordTypeId >= _examRecordType.length) {
      return "";
    }
    return _examRecordType[_selectedExamRecordTypeId];
  }

  String get showModeName {
    if (_examCountMode == null ||
        _selectedExamCountModeId >= _examCountMode.length) {
      return "";
    }
    return _examCountMode[_selectedExamCountModeId];
  }

  String get govType {
    if (_examGovType == null ||
        _selectedExamGovTypeId >= _examGovType.length) {
      return "";
    }
    return _examGovType[_selectedExamGovTypeId];
  }

  int get year {
    if (_years == null ||
        _selectedYearId >= _years.length) {
      return _years[_years.length - 1];
    }
    return _years[_selectedYearId];
  }

  List<ExamSeparated> _getExamPage(String examPageName) {
    return _exams.where((i) => i.name == examPageName).toList();
  }

  Map<String, List<ExamSeparated>> _getGroupedResults() {
    final page = _getExamPage(pageName);
    var filtered = page;

    switch (_selectedExamGovTypeId) {
      case 1:
        filtered = page.where((i) => i.authorityGovtCode == 'G').toList();
        break;
      case 2:
        filtered = page.where((i) => i.authorityGovtCode == 'N').toList();
        break;
    }

    if (_selectedAuthorityId >= 0) {
      filtered = filtered.where((i) => i.authorityCode == authorityName).toList();
    }

    if (_selectedYearId >= 0) {
      filtered = filtered.where((i) => i.year == year).toList();
    }
    return filtered
        .where((i) => i.recordType == recordTypeName)
        .toList()
        .groupBy((it) => it.key);
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByBenchmark() {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        if (groupedByBenchmarkData.containsKey(kNoTitleKey)) {
          groupedByBenchmarkData[kNoTitleKey].add(exam);
        } else {
          groupedByBenchmarkData[kNoTitleKey] = [exam];
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByYear() {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        final year = exam.year.toString();
        if (groupedByBenchmarkData.containsKey(year)) {
          groupedByBenchmarkData[year].add(exam);
        } else {
          groupedByBenchmarkData[year] = [exam];
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByState(Lookups lookups) {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        final district = exam.districtCode.from(lookups.districts);
        if (district != '') {
          if (groupedByBenchmarkData.containsKey(district)) {
            groupedByBenchmarkData[district].add(exam);
          } else {
            groupedByBenchmarkData[district] = [exam];
          }
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, List<ExamSeparated>>> getExamResults(Lookups lookups) {
    switch (_selectedExamViewId) {
      case 1:
        return _getExamResultsByYear();
        break;
      case 2:
        return _getExamResultsByState(lookups);
        break;
      default:
        return _getExamResultsByBenchmark();
    }
  }
}
