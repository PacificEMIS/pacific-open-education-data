import 'dart:core';
import 'package:collection/collection.dart';
import 'package:pacific_dashboards/src/models/ExamModel.dart';
import 'package:pacific_dashboards/src/models/ExamsModel.dart';

class ExamsDataNavigator {
  static const String kNoTitleKey = "";
  int _selectedExamPageId = 0;
  int _selectedExamViewId = 0;
  int _selectedExamStandardId = 0;

  List<String> _examPages;
  List<String> _examViews = [
    "By Benchmarks and Gender",
    "By Standards and Gender for Last 3 Years",
    "By Standards and State"
  ];
  List<String> _examStandards;
  List<ExamModel> _exams;
  ExamsModel _examsModel;

  ExamsDataNavigator(List<ExamModel> exams, ExamsModel examsModel) {
    _exams = exams;
    _examPages = _getExamPageNames();
    _examsModel = examsModel;
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
      _selectedExamPageId = _examPages.length - 1;
    }
    if (_selectedExamPageId > _examPages.length - 1) {
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

  String getExamPageName() {
    if (_examPages == null || _selectedExamPageId >= _examPages.length) {
      return "";
    }
    return _examPages[_selectedExamPageId];
  }

  String getExamViewName() {
    if (_examViews == null || _selectedExamViewId >= _examViews.length) {
      return "";
    }
    return _examViews[_selectedExamViewId];
  }

  String getStandardName() {
    if (_examStandards == null ||
        _selectedExamStandardId >= _examStandards.length) {
      return "";
    }
    return _examStandards[_selectedExamStandardId];
  }

  List<ExamModel> _getExamPage(String examPageName) {
    var filteredList = _exams.where((i) => i.exam == examPageName).toList();
    return filteredList;
  }

  List<String> _getExamPageNames() {
    return (List<String>.generate(_exams.length, (i) => _exams[i].exam).toSet())
        .toList();
  }

  List<String> _getStandardsNames() {
    var filteredList = _getExamPage(getExamPageName());
    return (List<String>.generate(
            filteredList.length, (i) => filteredList[i].examStandard).toSet())
        .toList();
  }

  Map<String, List<ExamModel>> _getGroupedResults() {
    var l = _getExamPage(getExamPageName());
    var filteredList =
        l.where((i) => i.examStandard == getStandardName()).toList();
    return groupBy(filteredList, (obj) => obj.examBenchmark);
  }

  Map<String, Map<String, ExamModel>> _getExamResultsByBenchmark() {
    var groupedData = _getGroupedResults();
    Map<String, Map<String, ExamModel>> results =
        new Map<String, Map<String, ExamModel>>();
    groupedData.forEach((k, v) {
      var groupedByBenchmarkData = new Map<String, ExamModel>();
      for (var item in v) {
        if (groupedByBenchmarkData.containsKey(kNoTitleKey)) {
          groupedByBenchmarkData[kNoTitleKey] =
              ExamModel.sum(groupedByBenchmarkData[kNoTitleKey], item);
        } else {
          groupedByBenchmarkData[kNoTitleKey] = item;
        }
      }
      results[k] = groupedByBenchmarkData;
    });
    return results;
  }

  Map<String, Map<String, ExamModel>> _getExamResultsByYear() {
    var groupedData = _getGroupedResults();
    Map<String, Map<String, ExamModel>> results =
        new Map<String, Map<String, ExamModel>>();
    groupedData.forEach((k, v) {
      var groupedByYearData = new Map<String, ExamModel>();
      for (var item in v) {
        if (groupedByYearData.containsKey(item.examYear)) {
          groupedByYearData[item.examYear.toString()] =
              ExamModel.sum(groupedByYearData[item.examYear.toString()], item);
        } else {
          groupedByYearData[item.examYear.toString()] = item;
        }
      }
      results[k] = groupedByYearData;
    });
    return results;
  }

  Map<String, Map<String, ExamModel>> _getExamResultsByState() {
    var groupedData = _getGroupedResults();
    Map<String, Map<String, ExamModel>> results =
        new Map<String, Map<String, ExamModel>>();
    groupedData.forEach((k, v) {
      var groupedByStateData = new Map<String, ExamModel>();
      for (var item in v) {
        var fullName =
            _examsModel.lookupsModel.getFullState(item.districtCode.toString());
        if (groupedByStateData.containsKey(fullName)) {
          groupedByStateData[fullName] =
              ExamModel.sum(groupedByStateData[fullName], item);
        } else {
          groupedByStateData[fullName] = item;
        }
      }
      results[k] = groupedByStateData;
    });
    return results;
  }

  Map<String, Map<String, ExamModel>> getExamResults() {
    switch (_selectedExamViewId) {
      case 1:
        return _getExamResultsByYear();
        break;
      case 2:
        return _getExamResultsByState();
        break;
      default:
        return _getExamResultsByBenchmark();
    }
  }
}
