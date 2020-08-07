import 'dart:math';

import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_data.dart';
import 'package:pacific_dashboards/utils/collections.dart';
import 'package:rxdart/rxdart.dart';

class IndividualExamsViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;

  final Subject<ExamReportsFilteredData> _filterDataSubject = BehaviorSubject();
  final Subject<bool> _isFilteredDataLoadingSubject =
      BehaviorSubject.seeded(true);

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
    _loadExamReports();
  }

  Stream<ExamReportsFilteredData> get filteredDataStream =>
      _filterDataSubject.stream;

  Stream<bool> get filteredDataLoadingStream =>
      _isFilteredDataLoadingSubject.stream;

  void onNextYearFilterPressed() {
    _yearIndexForFilter++;
    if (_yearIndexForFilter >= _preparedViewModelData.sortedYears.length) {
      _yearIndexForFilter = 0;
    }
    _applyFilters();
  }

  void onPrevYearFilterPressed() {
    _yearIndexForFilter--;
    if (_yearIndexForFilter < 0) {
      _yearIndexForFilter = _preparedViewModelData.sortedYears.length - 1;
    }
    _applyFilters();
  }

  void onNextExamFilterPressed() {
    _examCodeIndexForFilter++;
    if (_examCodeIndexForFilter >=
        _preparedViewModelData
            .sortedExamCodesByYear[_yearIndexForFilter].length) {
      _examCodeIndexForFilter = 0;
    }
    _applyFilters();
  }

  void onPrevExamFilterPressed() {
    _examCodeIndexForFilter--;
    if (_examCodeIndexForFilter < 0) {
      _examCodeIndexForFilter = _preparedViewModelData
              .sortedExamCodesByYear[_yearIndexForFilter].length -
          1;
    }
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

      _applyFilters();
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
        byGender: null,
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
