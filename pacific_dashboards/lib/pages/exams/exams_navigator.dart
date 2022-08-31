import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

import '../../models/exam/exam_separated.dart';
import '../../models/filter/filter.dart';
import 'exams_filter_data.dart';

class ExamsNavigator {
  static const String kNoTitleKey = "";
  int _selectedExamRecordTypeId = 0;
  int _selectedExamCountModeId = 0;

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

  final List<ExamSeparated> _exams;


  ExamsNavigator(List<ExamSeparated> exams)
      : _exams = exams;


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

  Map<String, Map<String, Map<String, List<ExamSeparated>>>> getExamResults(
      ExamsFilterData filterData, Lookups lookups) {
    return {
      'results' : _getExamResultsAll(filterData),
      'resultsByState' : _getExamResultsByState(filterData, lookups),
      'resultsByYear' : _getExamResultsByYear(filterData),
      'resultsByGovtNonGovt' : _getExamResultsByGov(filterData, lookups),
      'resultByGender' : _getExamResultsByGender(filterData, lookups)
    };
  }

  Map<String, List<ExamSeparated>> _getFiltered(
      ExamsFilterData filterData, {
        bool byYear = true,
        bool byState = true,
        bool byGovernment = true
      }) {
    var filtered = _exams
        .where((i) => i.name == filterData.examFilter.stringValue).toList();

    if (!filterData.yearFilter.isDefault && byYear) {
      filtered = filtered.where((i) => i.year == filterData.yearFilter.intValue)
          .toList();
    }

    if (!filterData.govFilter.isDefault && byGovernment) {
      filtered = filtered.where((i) => i.authorityGovtCode ==
          filterData.govFilter.stringValue).toList();
    }

    if (!filterData.stateFilter.isDefault && byState) {
      filtered = filtered.where((i) => i.districtCode ==
          filterData.stateFilter.stringValue).toList();
    }

    if (!filterData.authorityFilter.isDefault) {
      filtered = filtered.where((i) => i.authorityCode ==
          filterData.authorityFilter.stringValue).toList();
    }

    return filtered
        .where((i) => i.recordType == recordTypeName)
        .toList()
        .groupBy((it) => it.key);
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsAll(
      ExamsFilterData filterData) {
    return _getFiltered(filterData).map((benchmark, exams) {
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

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByState(
      ExamsFilterData filterData, Lookups lookups) {
    return _getFiltered(filterData, byState: false).map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        final state = exam.districtCode.toString().from(lookups.districts);
        if (groupedByBenchmarkData.containsKey(state)) {
          groupedByBenchmarkData[state].add(exam);
        } else {
          groupedByBenchmarkData[state] = [exam];
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByYear(
      ExamsFilterData filterData) {
    return _getFiltered(filterData, byYear: false).map((benchmark, exams) {
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

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByGov(
      ExamsFilterData filterData, Lookups lookups) {
    return _getFiltered(filterData, byGovernment: false).map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        final gov = exam.authorityGovtCode.toString().from(lookups.authorityGovt);
        if (groupedByBenchmarkData.containsKey(gov)) {
          groupedByBenchmarkData[gov].add(exam);
        } else {
          groupedByBenchmarkData[gov] = [exam];
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }

  Map<String, Map<String, List<ExamSeparated>>> _getExamResultsByGender(
      ExamsFilterData filterData, Lookups lookups) {
    return _getFiltered(filterData).map((benchmark, exams) {
      final groupedByBenchmarkData = Map<String, List<ExamSeparated>>();
      exams.forEach((exam) {
        final gender = exam.gender.toString();
        if (groupedByBenchmarkData.containsKey(gender)) {
          groupedByBenchmarkData[gender].add(exam);
        } else {
          groupedByBenchmarkData[gender] = [exam];
        }
      });
      return MapEntry(benchmark, groupedByBenchmarkData);
    });
  }
}
