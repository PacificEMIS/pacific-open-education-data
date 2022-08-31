import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/exams/exams_filter_data.dart';
import 'package:pacific_dashboards/pages/exams/exams_navigator.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/exam/exam_separated.dart';

class ExamsViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<ExamsFilterData> _filtersSubject = BehaviorSubject();
  final Subject<Map<String, Map<String, List<ExamSeparated>>>> _dataSubject =
      BehaviorSubject();

  ExamsNavigator _navigator;
  Lookups _lookups;

  ExamsViewModel(
    BuildContext ctx, {
    @required Repository repository,
    @required RemoteConfig remoteConfig,
    @required GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _dataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _loadNote();
    _loadData();
  }

  void _loadNote() {
    launchHandled(() async {
      final note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.exams)
          ?.note;
      _pageNoteSubject.add(note);
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: () => _repository.fetchAllExams()),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  Future<void> _onDataLoaded(List<ExamSeparated> exams) => launchHandled(
        () async {
          _lookups = await _repository.lookups.first;
          _navigator = ExamsNavigator(exams);
          _updatePageData();
        },
      );

  void _updatePageData() {
    launchHandled(() {
      _dataSubject.add(_convertExams());
      _filtersSubject.add(_filterData);
    });
  }

  ExamsFilterData get _filterData {
    final authorities = _lookups.authorities.where((e) => e
        .code == _navigator.authorityName);
    return ExamsFilterData(
        _navigator.pageName,
        _navigator.viewName,
        _navigator.showModeId,
        _navigator.recordTypeName,
        _navigator.showModeName,
        _navigator.govType,
        authorities.isNotEmpty
            ? authorities.first.name
            : _navigator.authorityName,
        _navigator.year.toString()
    );
  }

  Map<String, Map<String, List<ExamSeparated>>> _convertExams() {
    return _navigator.getExamResults(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<Map<String, Map<String, List<ExamSeparated>>>> get dataStream => _dataSubject.stream;

  Stream<ExamsFilterData> get filtersStream => _filtersSubject.stream;

  ///TODO WTF Rewrite this ***!!!
  void onPrevExamPressed() {
    _navigator.prevExamPage();
    _updatePageData();
  }

  void onNextExamPressed() {
    _navigator.nextExamPage();
    _updatePageData();
  }

  void onPrevViewPressed() {
    _navigator.prevExamView();
    _updatePageData();
  }

  void onNextViewPressed() {
    _navigator.nextExamView();
    _updatePageData();
  }

  void onPrevRecordTypePressed() {
    _navigator.prevExamRecordType();
    _updatePageData();
  }

  void onNextRecordTypePressed() {
    _navigator.nextExamRecordType();
    _updatePageData();
  }

  void onPrevShowModePressed() {
    _navigator.prevExamCountMode();
    _updatePageData();
  }

  void onNextShowModePressed() {
    _navigator.nextExamCountMode();
    _updatePageData();
  }

  void onPrevGovTypePressed() {
    _navigator.prevExamGovType();
    _updatePageData();
  }

  void onNextGovTypePressed() {
    _navigator.nextExamGovType();
    _updatePageData();
  }

  void onPrevAuthorityPressed() {
    _navigator.prevExamAuthority();
    _updatePageData();
  }

  void onNextAuthorityPressed() {
    _navigator.nextExamAuthority();
    _updatePageData();
  }

  void onPrevYearPressed() {
    _navigator.prevExamYear();
    _updatePageData();
  }

  void onNextYearPressed() {
    _navigator.nextExamYear();
    _updatePageData();
  }
}
