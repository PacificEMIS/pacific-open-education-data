import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/collections.dart';

class ExamsNavigator {
  static const String kNoTitleKey = "";
  int _selectedExamPageId = 0;
  int _selectedExamViewId = 0;
  int _selectedExamStandardId = 0;

  final List<String> _examPageNames;
  final List<String> _examViews = [
    AppLocalizations.examsByBenchmarkAndGender,
    AppLocalizations.examsByStandardsAndGender,
    AppLocalizations.examsByStandardsAndState,
  ];
  final List<Exam> _exams;

  List<String> _examStandards;

  ExamsNavigator(List<Exam> exams)
      : _examPageNames = exams.uniques((it) => it.name),
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

    _changeExamStandard();
  }

  void nextExamView() {
    _selectedExamViewId++;
    _changeExamView();
  }

  void prevExamView() {
    _selectedExamViewId--;
    _changeExamView();
  }

  void _changeExamView() {
    if (_selectedExamViewId < 0) {
      _selectedExamViewId = _examViews.length - 1;
    }
    if (_selectedExamViewId > _examViews.length - 1) {
      _selectedExamViewId = 0;
    }

    _changeExamStandard();
  }

  void nextExamStandard() {
    _selectedExamStandardId++;
    _changeExamStandard();
  }

  void prevExamStandard() {
    _selectedExamStandardId--;
    _changeExamStandard();
  }

  void _changeExamStandard() {
    _examStandards = _getStandardsNames();
    if (_selectedExamStandardId < 0) {
      _selectedExamStandardId = _examStandards.length - 1;
    }
    if (_selectedExamStandardId > _examStandards.length - 1) {
      _selectedExamStandardId = 0;
    }
  }

  String get pageName {
    if (_examPageNames == null ||
        _selectedExamPageId >= _examPageNames.length) {
      return "";
    }
    return _examPageNames[_selectedExamPageId];
  }

  String get viewName {
    if (_examViews == null || _selectedExamViewId >= _examViews.length) {
      return "";
    }
    return _examViews[_selectedExamViewId];
  }

  String get standardName {
    if (_examStandards == null ||
        _selectedExamStandardId >= _examStandards.length) {
      return "";
    }
    return _examStandards[_selectedExamStandardId];
  }

  List<Exam> _getExamPage(String examPageName) {
    return _exams.where((i) => i.name == examPageName).toList();
  }

  List<String> _getStandardsNames() {
    return _getExamPage(pageName).uniques((it) => it.standard);
  }

  Map<String, List<Exam>> _getGroupedResults() {
    final page = _getExamPage(pageName);
    return page
        .where((i) => i.standard == standardName)
        .toList()
        .groupBy((it) => it.benchmark);
  }

  Map<String, Map<String, Exam>> _getExamResultsByBenchmark() {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, Exam>();
      exams.forEach((exam) {
        if (groupedByBenchmarkData.containsKey(kNoTitleKey)) {
          groupedByBenchmarkData[kNoTitleKey] =
              groupedByBenchmarkData[kNoTitleKey] + exam;
        } else {
          groupedByBenchmarkData[kNoTitleKey] = exam;
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, Exam>> _getExamResultsByYear() {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, Exam>();
      exams.forEach((exam) {
        final year = exam.year.toString();
        if (groupedByBenchmarkData.containsKey(year)) {
          groupedByBenchmarkData[year] = groupedByBenchmarkData[year] + exam;
        } else {
          groupedByBenchmarkData[year] = exam;
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, Exam>> _getExamResultsByState(
      Lookups lookups) {
    return _getGroupedResults().map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, Exam>();
      exams.forEach((exam) {
        final district = exam.districtCode.from(lookups.districts);
        if (groupedByBenchmarkData.containsKey(district)) {
          groupedByBenchmarkData[district] =
              groupedByBenchmarkData[district] + exam;
        } else {
          groupedByBenchmarkData[district] = exam;
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, Exam>> getExamResults(Lookups lookups) {
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
