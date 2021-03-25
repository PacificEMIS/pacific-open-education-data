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
import 'package:screen/screen.dart';

class DownloadViewModel extends ViewModel {
  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;
  final Repository _repository;

  final _stateSubject = BehaviorSubject<DownloadPageState>.seeded(
    PreparationDownloadPageState.initial(),
  );

  Stream<DownloadPageState> get stateStream => _stateSubject.stream;

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

  void onIndividualSchoolEnabledChanged(bool newValue) {
    final currentState = _stateSubject.value;
    if (currentState is! PreparationDownloadPageState) {
      throw StateError('cannot change individual schools enabled '
          'outside from PreparationDownloadPageState');
    }
    _stateSubject.add(
      (currentState as PreparationDownloadPageState)
          .copyWith(areIndividualSchoolsEnabled: newValue),
    );
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
        await _downloadItems(Queue.of(state.failedToLoadItems));
      }),
    );
  }

  LoadingItem _mapLoadingSubjectToLoadingItem(LoadingSubject e) {
    switch (e) {
      case LoadingSubject.lookups:
        return LoadingItem(subject: e, loadFn: _downloadLookups);
      case LoadingSubject.individualSchools:
        return LoadingItem(subject: e, loadFn: _downloadIndividualSchools);
      case LoadingSubject.schools:
        return LoadingItem(subject: e, loadFn: _downloadSchoolsEnrollmentData);
      case LoadingSubject.teachers:
        return LoadingItem(subject: e, loadFn: _downloadTeachersEnrollmentData);
      case LoadingSubject.exams:
        return LoadingItem(subject: e, loadFn: _downloadExamsData);
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

  Future<List<LoadingSubject>> _createLoadingSubjects() async {
    final currentState = _stateSubject.value as PreparationDownloadPageState;
    final sections = await _getSectionsForEmis(
      await _globalSettings.currentEmis,
    );

    final needToLoadIndividualSchools =
        currentState.areIndividualSchoolsEnabled;
    final loadingSubjects = <LoadingSubject>[];

    for (final subject in LoadingSubject.values) {
      switch (subject) {
        case LoadingSubject.lookups:
          loadingSubjects.add(subject);
          break;
        case LoadingSubject.individualSchools:
          if (needToLoadIndividualSchools &&
              sections.contains(Section.individualSchools)) {
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
    Screen.keepOn(true);

    var i = 0;
    final originalItemCount = items.length;
    var appendedItemCount = 0;

    while (items.isNotEmpty) {
      i++;
      final item = items.removeFirst();
      final state = _stateSubject.value as ActiveDownloadPageState;
      try {
        if (item.subject == LoadingSubject.individualSchools &&
            item is! IndividualSchoolsLoadingItem) {
          // this is a root of individual schools,
          // which will expand the total number of items
          final individualSchoolItems =
              (await item.loadFn()) as List<IndividualSchoolsLoadingItem>;
          appendedItemCount += individualSchoolItems.length;
          for (final item in individualSchoolItems.reversed) {
            items.addFirst(item);
          }
        } else {
          await item.loadFn();
        }
      } catch (ex) {
        final errors = state.failedToLoadItems;
        _stateSubject.add(state.copyWith(failedToLoadItems: errors..add(item)));
      }
      final total = originalItemCount + appendedItemCount;
      _stateSubject.add(state.copyWith(
        currentIndex: i,
        total: total,
      ));
    }

    _stateSubject.add(
      (_stateSubject.value as ActiveDownloadPageState)
          .copyWith(isDownloading: false),
    );

    Screen.keepOn(false);
  }

  void onCancelPressed() {
    _downloadOp?.cancel();
    navigator.pop();
    Screen.keepOn(false);
  }

  Future<List<Section>> _getSectionsForEmis(Emis emis) async {
    final emisesConfig = await _remoteConfig.emises;

    EmisConfig emisConfig = emisesConfig.getEmisConfigFor(emis);
    if (emisConfig == null) {
      return [];
    }

    return emisConfig.modules
        .map((config) => config.asSection())
        .where((it) => it != null)
        .toList();
  }

  Future<void> _downloadLookups() async {
    try {
      await _repository.refreshLookups();
    } catch (t) {
      throw _LoadingException();
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
            completer.completeError(_LoadingException());
          }
        }
      },
      onError: (e) {
        if (!completer.isCompleted) {
          completer.completeError(_LoadingException());
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

  Future<List<IndividualSchoolsLoadingItem>>
      _downloadIndividualSchools() async {
    final responses = await _repository.fetchSchoolsList().toList();
    if (responses.length < 2) {
      throw _LoadingException();
    }

    List<ShortSchool> schools;
    if (responses.last is FailureRepositoryResponse &&
        responses.last.type == RepositoryType.remote) {
      if (responses.first.data == null) {
        throw _LoadingException();
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
}

class _LoadingException implements Exception {}
