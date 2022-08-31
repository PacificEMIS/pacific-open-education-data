import 'dart:async';
import 'dart:collection';

import 'package:arch/arch.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/download/loading_item.dart';
import 'package:pacific_dashboards/pages/download/state.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock/wakelock.dart';

import 'error_item.dart';

class DownloadViewModel extends ViewModel {
  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;
  final Repository _repository;

  String _searchQuery = '';
  final _stateSubject = BehaviorSubject<DownloadPageState>.seeded(
    PreparationDownloadPageState.initial(),
  );

  Stream<DownloadPageState> get stateStream => _stateSubject.stream;
  List<ShortSchool>  selectedSchools;
  List<ShortSchool>  individualSchools;
  CancelableOperation _downloadOp;

  DownloadViewModel(
    BuildContext ctx, {
    @required GlobalSettings globalSettings,
    @required RemoteConfig remoteConfig,
    @required Repository repository,
  })  : assert(globalSettings != null),
        assert(remoteConfig != null),
        assert(repository != null),
        _globalSettings = globalSettings,
        _remoteConfig = remoteConfig,
        _repository = repository,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _stateSubject.disposeWith(disposeBag);
  }

  @override
  void dispose() {
    super.dispose();
    _downloadOp?.cancel();
  }

  void onSearchTextChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void onUpdateSchoolsList(List<ShortSchool> selectedSchools, List<ShortSchool> individualSchools) {
    this.selectedSchools = selectedSchools;
    this.individualSchools = individualSchools;

    if (selectedSchools.length < individualSchools.length) {
      final currentState = _stateSubject.value as PreparationDownloadPageState;
      if (currentState.sections.contains(Section.individualSchools)) {
        _stateSubject.add(
          (currentState as PreparationDownloadPageState).copyWith(section: Section.individualSchools),
        );
      }
    }
    _stateSubject.add(
        (_stateSubject.value as PreparationDownloadPageState));
  }
  void _applyFilters() {
    launchHandled(() {
      return;
    });
  }

  void onSelectedRegionValueChanged(Section section) {
    final currentState = _stateSubject.value as PreparationDownloadPageState;
    if (currentState is! PreparationDownloadPageState) {
      throw StateError('cannot change selected item enabled '
          'outside from PreparationDownloadPageState');
    }

    if (currentState.sections.contains(Section.individualSchools) && section == Section.individualSchools)
      selectedSchools = [];
    _stateSubject.add(
      (currentState as PreparationDownloadPageState).copyWith(section: section),
    );
  }

  void onSelectAllSectionsPressed(List<Section> sections) {
    final currentState = _stateSubject.value;
    if (currentState is! PreparationDownloadPageState) {
      throw StateError('cannot change selected item enabled '
          'outside from PreparationDownloadPageState');
    }

    _stateSubject.add(
      (currentState as PreparationDownloadPageState).copyWithSections(sections: sections),
    );
  }

  bool isAllSchoolSelected() {
    final currentState = _stateSubject.value as PreparationDownloadPageState;
    return currentState.sections.contains(Section.individualSchools);
  }

  void onDownloadPressed() {
    _downloadOp = CancelableOperation.fromFuture(
      Future.microtask(() async {
        final subjectsToLoad = await _createLoadingSubjects();
        final loadingItems = subjectsToLoad.map((e) {
          return _mapLoadingSubjectToLoadingItem(e);
        }).toList();
        _stateSubject.add(
          ActiveDownloadPageState.initial(total: loadingItems.length),
        );
        await _downloadItems(Queue.of(loadingItems));
      }),
    );
  }

  void onDonePressed() {
    navigator.pop();
    navigator.pop();
  }

  void onRestartPressed() {
    final state = _stateSubject.value as ActiveDownloadPageState;
    _downloadOp = CancelableOperation.fromFuture(
      Future.microtask(() async {
        _stateSubject.add(
          ActiveDownloadPageState.initial(
            total: state.failedToLoadItems.length,
          ),
        );
        await _downloadItems(Queue.of(state.failedToLoadItems.map((e) => e.item).toList()));
      }),
    );
  }

  LoadingItem _mapLoadingSubjectToLoadingItem(LoadingSubject e) {
    switch (e) {
      case LoadingSubject.lookups:
        return LoadingItem(subject: e, loadFn: _downloadLookups);
      case LoadingSubject.individualSchools:
        return LoadingItem(
            subject: e,
            loadFn: selectedSchools == null || selectedSchools.length == 0 ? _downloadIndividualSchools :
            _downloadSelectedIndividualSchools);
      case LoadingSubject.schools:
        return LoadingItem(subject: e, loadFn: _downloadSchoolsEnrollmentData);
      case LoadingSubject.teachers:
        return LoadingItem(subject: e, loadFn: _downloadTeachersEnrollmentData);
      case LoadingSubject.exams:
        return LoadingItem(subject: e, loadFn: _downloadExamsData);
      case LoadingSubject.indicators:
        return LoadingItem(subject: e, loadFn: _downloadIndicatorsData);
      case LoadingSubject.schoolAccreditations:
        return LoadingItem(subject: e, loadFn: _downloadAccreditationData);
      case LoadingSubject.budgets:
        return LoadingItem(subject: e, loadFn: _downloadBudgetsData);
      case LoadingSubject.wash:
        return LoadingItem(subject: e, loadFn: _downloadWashData);
      case LoadingSubject.specialEducation:
        return LoadingItem(subject: e, loadFn: _downloadSpecialData);
      case LoadingSubject.indicators:
        return LoadingItem(
          subject: e,
          loadFn: () => Future.delayed(const Duration(seconds: 1)),
        );
    }
    throw FallThroughError();
  }

  Future<List<Section>> getSections() async {
    final sections = await _getSectionsForEmis(
      await _globalSettings.currentEmis,
    );
    return sections;
  }

  bool isSectionsSelected() {
    final currentState = _stateSubject.value as PreparationDownloadPageState;
    if (currentState.sections == null) return false;
    return currentState.sections.length > 0;
  }


  Future<List<LoadingSubject>> _createLoadingSubjects() async {
    final currentState = _stateSubject.value as PreparationDownloadPageState;

    final sections = currentState.sections;
    final loadingSubjects = <LoadingSubject>[];
    if (selectedSchools != null && selectedSchools.length > 0) {
      loadingSubjects.add(LoadingSubject.individualSchools);
    }
    for (final subject in LoadingSubject.values) {
      switch (subject) {
        case LoadingSubject.lookups:
          loadingSubjects.add(subject);
          break;
        case LoadingSubject.individualSchools:
          if (sections.contains(Section.individualSchools)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.schools:
          if (sections.contains(Section.schools)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.teachers:
          if (sections.contains(Section.teachers)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.exams:
          if (sections.contains(Section.exams)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.schoolAccreditations:
          if (sections.contains(Section.schoolAccreditations)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.budgets:
          if (sections.contains(Section.budgets)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.wash:
          if (sections.contains(Section.wash)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.specialEducation:
          if (sections.contains(Section.specialEducation)) {
            loadingSubjects.add(subject);
          }
          break;
        case LoadingSubject.indicators:
          if (sections.contains(Section.indicators)) {
            loadingSubjects.add(subject);
          }
          break;
      }
    }

    return loadingSubjects;
  }

  Future<void> _downloadItems(Queue<LoadingItem> items) async {
    Wakelock.enable();

    var i = 0;
    final originalItemCount = items.length;
    var appendedItemCount = 0;

    while (items.isNotEmpty) {
      i++;
      final item = items.removeFirst();
      final state = _stateSubject.value as ActiveDownloadPageState;
      try {
        if (item.subject == LoadingSubject.individualSchools && item is! IndividualSchoolsLoadingItem) {
          // this is a root of individual schools,
          // which will expand the total number of items
          final individualSchoolItems = (await item.loadFn()) as List<IndividualSchoolsLoadingItem>;
          appendedItemCount += individualSchoolItems.length;
          for (final item in individualSchoolItems.reversed) {
            items.addFirst(item);
          }
        } else {
          await item.loadFn();
        }
      } catch (ex) {
        final errors = state.failedToLoadItems;
        _stateSubject.add(state.copyWith(failedToLoadItems: errors..add(ErrorItem(item: item, status: ex.toString())
        )));
      }
      final total = originalItemCount + appendedItemCount;
      _stateSubject.add(state.copyWith(
        currentIndex: i,
        total: total,
      ));
    }

    _stateSubject.add(
      (_stateSubject.value as ActiveDownloadPageState).copyWith(isDownloading: false),
    );

    Wakelock.disable();
  }

  void onCancelPressed() {
    _downloadOp?.cancel();
    navigator.pop();
    navigator.pop();
    navigator.pop();
    Wakelock.disable();
  }

  Future<List<Section>> _getSectionsForEmis(Emis emis) async {
    final emisesConfig = await _remoteConfig.emises;

    EmisConfig emisConfig = emisesConfig.getEmisConfigFor(emis);
    if (emisConfig == null) {
      return [];
    }

    return emisConfig.modules.map((config) => config.asSection()).where((it) => it != null).toList();
  }

  Future<void> _downloadLookups() async {
    try {
      await _repository.refreshLookups();
    } catch (t) {
      throw Exception(t);
    }
  }

  Future<void> _downloadSchoolsEnrollmentData() {
    return _downloadHandled(_repository.fetchAllSchools());
  }

  Future<void> _downloadHandled(
    Stream<RepositoryResponse> stream,
  ) {
    final completer = Completer<void>();
    stream.listen(
      (response) {
        if (response is FailureRepositoryResponse &&
            response.type == RepositoryType.remote &&
            response.throwable is! NoDataException) {
          if (!completer.isCompleted) {
            completer.completeError(Exception('Data already loaded'));
          }
        }
      },
      onError: (e) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Server error'));
        }
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      cancelOnError: true,
    ).disposeWith(disposeBag);
    return completer.future;
  }

  Future<void> _downloadTeachersEnrollmentData() async {
    return _downloadHandled(_repository.fetchAllTeachers());
  }

  Future<void> _downloadExamsData() async {
    return _downloadHandled(_repository.fetchAllExams());
  }

  Future<void> _downloadIndicatorsData() async {
    var emis = await _globalSettings.currentEmis;
    List<String> districts = [""];
    if (emis == Emis.fedemis) {
      var lookups = await _repository.lookups.first;
      lookups.districts.forEach((element) {
        districts.add(element.code);
      });
    }
    return Future.wait(districts.map((district) => _downloadHandled(_repository.fetchAllIndicators(district))));
  }

  Future<void> _downloadAccreditationData() async {
    return _downloadHandled(_repository.fetchAllAccreditations());
  }

  Future<void> _downloadBudgetsData() async {
    return _downloadHandled(_repository.fetchAllBudgets());
  }

  Future<void> _downloadWashData() async {
    return _downloadHandled(_repository.fetchAllWashChunk());
  }

  Future<void> _downloadSpecialData() async {
    return _downloadHandled(_repository.fetchAllSpecialEducation());
  }

  Future<List<IndividualSchoolsLoadingItem>> _downloadIndividualSchools() async {
    final responses = await _repository.fetchSchoolsList().toList();
    if (responses.length < 2) {
      throw Exception('Response error');
    }

    List<ShortSchool> schools;
    if (responses.last is FailureRepositoryResponse && responses.last.type == RepositoryType.remote) {
      if (responses.first.data == null) {
        throw Exception('Null data');
      } else {
        schools = responses.first.data;
      }
    } else {
      schools = responses.last.data;
    }

    return schools.map((school) {
      final id = school.id;
      return IndividualSchoolsLoadingItem(
        schoolId: id,
        districtCode: school.districtCode,
        loadFn: (id, districtCode) async {
          await _downloadHandled(_repository.fetchIndividualSchool(id));
          await _downloadHandled(
            _repository.fetchIndividualSchoolEnroll(id, school.districtCode),
          );
          await _downloadHandled(_repository.fetchIndividualSchoolExams(id));
          await _downloadHandled(_repository.fetchIndividualSchoolFlow(id));
        },
      );
    }).toList();
  }

  Future<List<IndividualSchoolsLoadingItem>> _downloadSelectedIndividualSchools() async {
    return selectedSchools.map((school) {
      final id = school.id;
      return IndividualSchoolsLoadingItem(
        schoolId: id,
        districtCode: school.districtCode,
        loadFn: (id, districtCode) async {
          await _downloadHandled(_repository.fetchIndividualSchool(id));
          await _downloadHandled(
            _repository.fetchIndividualSchoolEnroll(id, school.districtCode),
          );
          await _downloadHandled(_repository.fetchIndividualSchoolExams(id));
          await _downloadHandled(_repository.fetchIndividualSchoolFlow(id));
        },
      );
    }).toList();
  }
}

