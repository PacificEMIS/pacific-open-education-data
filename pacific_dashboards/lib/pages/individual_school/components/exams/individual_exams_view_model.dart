import 'dart:math';

import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/components/individual_exams_filter.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_data.dart';
import 'package:rxdart/rxdart.dart';

class IndividualExamsViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;

  final Subject<ExamReportsFilteredData> _filterDataSubject = BehaviorSubject();
  final Subject<List<ExamReportsHistoryByYearData>> _historyRowsSubject =
      BehaviorSubject.seeded([]);
  final Subject<IndividualExamsFiltersData> _filterViewDataSubject =
      BehaviorSubject();
  final Subject<bool> _isFilteredDataLoadingSubject =
      BehaviorSubject.seeded(true);
  final Subject<bool> _isHistoryDataLoadingSubject =
      BehaviorSubject.seeded(true);
  final Subject<bool> _haveDataSubject = BehaviorSubject.seeded(false);

  _PreparedViewModelData _preparedViewModelData;

  int _yearIndexForFilter = 0;
  int _examCodeIndexForFilter = 0;

  IndividualExamsViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _filterDataSubject.disposeWith(disposeBag);
    _isFilteredDataLoadingSubject.disposeWith(disposeBag);
    _filterViewDataSubject.disposeWith(disposeBag);
    _historyRowsSubject.disposeWith(disposeBag);
    _isHistoryDataLoadingSubject.disposeWith(disposeBag);
    _haveDataSubject.disposeWith(disposeBag);
    _loadExamReports();
  }

  Stream<ExamReportsFilteredData> get filteredDataStream =>
      _filterDataSubject.stream;

  Stream<IndividualExamsFiltersData> get filterViewDataStream =>
      _filterViewDataSubject.stream;

  Stream<bool> get filteredDataLoadingStream =>
      _isFilteredDataLoadingSubject.stream;

  Stream<bool> get historyDataLoadingStream =>
      _isHistoryDataLoadingSubject.stream;

  Stream<bool> get haveDataStream => _haveDataSubject.stream;

  Stream<List<ExamReportsHistoryByYearData>> get historyRowsStream =>
      _historyRowsSubject.stream;

  void _notifyFilterViewDataChanged() {
    final year = _preparedViewModelData.sortedYears[_yearIndexForFilter];
    _filterViewDataSubject.add(IndividualExamsFiltersData(
      year,
      _preparedViewModelData.sortedExamCodesByYear[year]
          [_examCodeIndexForFilter],
    ));
  }

  void onNextYearFilterPressed() {
    _yearIndexForFilter++;
    if (_yearIndexForFilter >= _preparedViewModelData.sortedYears.length) {
      _yearIndexForFilter = 0;
    }
    _examCodeIndexForFilter = 0;
    _notifyFilterViewDataChanged();
    _applyFilters();
  }

  void onPrevYearFilterPressed() {
    _yearIndexForFilter--;
    if (_yearIndexForFilter < 0) {
      _yearIndexForFilter = _preparedViewModelData.sortedYears.length - 1;
    }
    _examCodeIndexForFilter = 0;
    _notifyFilterViewDataChanged();
    _applyFilters();
  }

  void onNextExamFilterPressed() {
    _examCodeIndexForFilter++;
    if (_examCodeIndexForFilter >=
        _preparedViewModelData
            .sortedExamCodesByYear[
                _preparedViewModelData.sortedYears[_yearIndexForFilter]]
            .length) {
      _examCodeIndexForFilter = 0;
    }
    _notifyFilterViewDataChanged();
    _applyFilters();
  }

  void onPrevExamFilterPressed() {
    _examCodeIndexForFilter--;
    if (_examCodeIndexForFilter < 0) {
      _examCodeIndexForFilter = _preparedViewModelData
              .sortedExamCodesByYear[
                  _preparedViewModelData.sortedYears[_yearIndexForFilter]]
              .length -
          1;
    }
    _notifyFilterViewDataChanged();
    _applyFilters();
  }

  void _loadExamReports() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolExams(_school.id),
    )
        .doOnListen(() => notifyHaveProgress(true))
        .listen(
          _onExamReportsLoaded,
          onError: (t) => handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onExamReportsLoaded(List<SchoolExamReport> reports) {
    launchHandled(() async {
      final groupedByYear = reports.groupBy((it) => it.year);
      groupedByYear.removeWhere((k, v) => k == null);
      final sortedYears =
          groupedByYear.keys.chainSort((lv, rv) => rv.compareTo(lv)).toList();
      final reportsByYearAndExamCode = sortedYears.asMap().map(
            (key, value) => MapEntry(
              value,
              groupedByYear[value].groupBy((it) => it.examCode),
            ),
          );
      final sortedExamCodesByYear = reportsByYearAndExamCode.map(
        (year, reportsByExamCode) => MapEntry(
          year,
          reportsByExamCode.keys
              .chainSort((lv, rv) => lv.compareTo(rv))
              .toList(),
        ),
      );

      _preparedViewModelData = _PreparedViewModelData(
        sortedYears: sortedYears,
        sortedExamCodesByYear: sortedExamCodesByYear,
        reportsByYearAndExamCode: reportsByYearAndExamCode,
      );

      notifyHaveProgress(false);

      _haveDataSubject.add(reports.isNotEmpty);

      if (reports.isNotEmpty) {
        _notifyFilterViewDataChanged();
        _createHistoryByYears();
        _applyFilters();
      }
    });
  }

  void _createHistoryByYears() {
    launchHandled(() async {
      _isHistoryDataLoadingSubject.add(true);

      final viewModelData = _preparedViewModelData;
      final historyData = _generateHistoryData(viewModelData);
      _historyRowsSubject.add(historyData);

      //Removed compute - NAN issue(compute available types - null, num, bool, double, String)
      //
      // _historyRowsSubject.add(await compute(
      //       //   _generateHistoryData,
      //       //   viewModelData,
      //       // ));

      _isHistoryDataLoadingSubject.add(false);
    });
  }

  void _applyFilters() {
    launchHandled(() async {
      _isFilteredDataLoadingSubject.add(true);
      final year = _preparedViewModelData.sortedYears[_yearIndexForFilter];
      final examCode = _preparedViewModelData.sortedExamCodesByYear[year]
          [_examCodeIndexForFilter];

      final filteredReportsList =
          _preparedViewModelData.reportsByYearAndExamCode[year][examCode];

      _filterDataSubject.add(ExamReportsFilteredData(
        year: year,
        examName: filteredReportsList.first.examName,
        byBenchmark: await compute(
          _generateBenchmarkResults,
          filteredReportsList,
        ),
        byGender: await compute(
          _generateGenderResults,
          filteredReportsList,
        ),
      ));

      _isFilteredDataLoadingSubject.add(false);
    });
  }

  @override
  void handleThrows(Object thrownObject) {
    super.handleThrows(thrownObject);
    notifyHaveProgress(false);
    _isFilteredDataLoadingSubject.add(false);
  }
}

class _PreparedViewModelData {
  final List<int> sortedYears;
  final Map<int, List<String>> sortedExamCodesByYear;
  final Map<int, Map<String, List<SchoolExamReport>>> reportsByYearAndExamCode;

  const _PreparedViewModelData({
    @required this.sortedYears,
    @required this.sortedExamCodesByYear,
    @required this.reportsByYearAndExamCode,
  });
}

ExamReportsBenchmarkResults _generateBenchmarkResults(
  List<SchoolExamReport> reports,
) {
  final reportsByBenchmark = reports.groupBy((it) => it.benchmarkCode);
  final List<ExamReportsBenchmarkData> dataList = [];

  var maxNegativeCandidates = 0;
  var maxPositiveCandidates = 0;

  reportsByBenchmark.forEach((benchmarkCode, values) {
    final wellBelowCandidates = _getTotalCandidatesWithLevel(1, values);
    final approachingCandidates = _getTotalCandidatesWithLevel(2, values);
    final minimallyCandidates = _getTotalCandidatesWithLevel(3, values);
    final competentCount = _getTotalCandidatesWithLevel(4, values);

    maxNegativeCandidates = max(
      maxNegativeCandidates,
      wellBelowCandidates + approachingCandidates,
    );

    maxPositiveCandidates = max(
      maxPositiveCandidates,
      minimallyCandidates + competentCount,
    );

    dataList.add(ExamReportsBenchmarkData(
      benchmarkCode: benchmarkCode,
      benchmarkDescription: values.first.benchmarkDescription,
      wellBelowCount: wellBelowCandidates,
      approachingCount: approachingCandidates,
      minimallyCount: minimallyCandidates,
      competentCount: competentCount,
    ));
  });
  return ExamReportsBenchmarkResults(
    maxNegativeCandidates: maxNegativeCandidates,
    maxPositiveCandidates: maxPositiveCandidates,
    dataByBenchmark: dataList,
  );
}

int _getTotalCandidatesWithLevel(int level, List<SchoolExamReport> list) {
  return list
      .where((it) => it.achievementLevel == level)
      .map((it) => it.totalCandidates)
      .fold(0, (previousValue, element) => previousValue + element);
}

ExamReportsGenderResults _generateGenderResults(
  List<SchoolExamReport> reports,
) {
  final reportsByLevel = reports.groupBy((it) => it.achievementLevel);

  final wellBelowData = ExamReportsGenderData(male: 0, female: 0);
  final approachingData = ExamReportsGenderData(male: 0, female: 0);
  final minimallyData = ExamReportsGenderData(male: 0, female: 0);
  final competentData = ExamReportsGenderData(male: 0, female: 0);

  var maxMaleCandidates = 0;
  var maxFemaleCandidates = 0;

  reportsByLevel.forEach((level, reports) {
    switch (level) {
      case 1:
        wellBelowData.male = _getTotalMaleCandidates(reports);
        if (wellBelowData.male > maxMaleCandidates) {
          maxMaleCandidates = wellBelowData.male;
        }
        wellBelowData.female = _getTotalFemaleCandidates(reports);
        if (wellBelowData.female > maxFemaleCandidates) {
          maxFemaleCandidates = wellBelowData.female;
        }
        break;
      case 2:
        approachingData.male = _getTotalMaleCandidates(reports);
        if (approachingData.male > maxMaleCandidates) {
          maxMaleCandidates = approachingData.male;
        }
        approachingData.female = _getTotalFemaleCandidates(reports);
        if (approachingData.female > maxFemaleCandidates) {
          maxFemaleCandidates = approachingData.female;
        }
        break;
      case 3:
        minimallyData.male = _getTotalMaleCandidates(reports);
        if (minimallyData.male > maxMaleCandidates) {
          maxMaleCandidates = minimallyData.male;
        }
        minimallyData.female = _getTotalFemaleCandidates(reports);
        if (minimallyData.female > maxFemaleCandidates) {
          maxFemaleCandidates = minimallyData.female;
        }
        break;
      case 4:
        competentData.male = _getTotalMaleCandidates(reports);
        if (competentData.male > maxMaleCandidates) {
          maxMaleCandidates = competentData.male;
        }
        competentData.female = _getTotalFemaleCandidates(reports);
        if (competentData.female > maxFemaleCandidates) {
          maxFemaleCandidates = competentData.female;
        }
        break;
    }
  });

  return ExamReportsGenderResults(
    maxFemaleCandidates: maxFemaleCandidates,
    maxMaleCandidates: maxMaleCandidates,
    competentData: competentData,
    minimallyData: minimallyData,
    approachingData: approachingData,
    wellBelowData: wellBelowData,
  );
}

int _getTotalMaleCandidates(List<SchoolExamReport> list) {
  return list
      .map((it) => it.maleCandidates)
      .fold(0, (previousValue, element) => previousValue + element);
}

int _getTotalFemaleCandidates(List<SchoolExamReport> list) {
  return list
      .map((it) => it.femaleCandidates)
      .fold(0, (previousValue, element) => previousValue + element);
}

List<ExamReportsHistoryByYearData> _generateHistoryData(
    _PreparedViewModelData data) {
  return data.sortedYears.map((year) {
    final dataByExamCode = data.reportsByYearAndExamCode[year];
    final sortedExamCodes = data.sortedExamCodesByYear[year];

    final List<ExamReportsHistoryRowData> rows = [];
    sortedExamCodes.forEach((examCode) {
      final reports = dataByExamCode[examCode];
      var maleCandidates = 0;
      var femaleCandidates = 0;
      reports.forEach((report) {
        maleCandidates += report.maleCandidates;
        femaleCandidates += report.femaleCandidates;
      });
      print('examCode');
      // print(reports.head.examName);
      rows.add(ExamReportsHistoryRowData(
        examCode: examCode ?? '-',
        examName: reports.head.examName,
        male: maleCandidates,
        female: femaleCandidates,
      ));
    });

    return ExamReportsHistoryByYearData(
      year: year,
      rows: rows,
    );
  }).toList();
}
