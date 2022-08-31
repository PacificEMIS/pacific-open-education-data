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
import '../../models/filter/filter.dart';

class ExamsViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<ExamsFilterData> _filtersSubject = BehaviorSubject();
  final Subject<Map<String, Map<String, Map<String, List<ExamSeparated>>>>> _dataSubject =
      BehaviorSubject();

  ExamsNavigator _navigator;
  List<Filter> _filters;
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
          _filters = [
            Filter(
              id: 0,
              title: 'filtersByYear',
              items: exams
                  .uniques((it) => it.year)
                  .chainSort((lv, rv) => rv.compareTo(lv))
                  .map((it) => FilterItem(it, it.toString()))
                  .toList(),
              selectedIndex: 0,
            ),
            Filter(
                id: 0,
                title: 'Exams',
                items: exams.uniques((it) => it.name)
                    .map((e) => FilterItem(e, e.toString())).toList(),
                selectedIndex: 0
            ),
            Filter(
              id: 0,
              title: 'filtersByState',
              items: [
                FilterItem(null, 'filtersDisplayAllStates'),
                ..._lookups.districts.where((e) => e.name != '').map((e) =>
                    FilterItem(e.code, e.name)).toList(),
              ],
              selectedIndex: 0,
            ),
            Filter(
                id: 0,
                title: 'filtersByGovernment',
                items: [
                  FilterItem(null, 'filtersDisplayAllGovernmentFilters'),
                  ..._lookups.authorityGovt.map((e) =>
                      FilterItem(e.code, e.name)).toList()
                ],
                selectedIndex: 0
            ),
            Filter(
                id: 0,
                title: 'filtersByAuthority',
                items: [
                  FilterItem(null, 'filtersDisplayAllAuthority'),
                  ..._lookups.authorities.map((e) =>
                      FilterItem(e.code, e.name)).toList(),
                ],
                selectedIndex: 0
            ),
          ];
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
    return ExamsFilterData(
        _navigator.showModeId,
        _navigator.recordTypeName,
        _navigator.showModeName,
        _filters
    );
  }

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      _updatePageData();
    });
  }

  Map<String, Map<String, Map<String, List<ExamSeparated>>>> _convertExams() {
    return _navigator.getExamResults(_filterData, _lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<Map<String, Map<String, Map<String, List<ExamSeparated>>>>> get dataStream => _dataSubject.stream;

  Stream<ExamsFilterData> get filtersStream => _filtersSubject.stream;

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
}
