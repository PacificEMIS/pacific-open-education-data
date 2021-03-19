import 'dart:async';

import 'package:arch/arch.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screen/screen.dart';

class DownloadDataDialogViewModel extends ViewModel {
  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;
  final Repository _repository;

  final _progressSubject = BehaviorSubject<double>.seeded(0.0);
  final _loadingErrorsSubject = BehaviorSubject<List<LoadingItem>>();
  final _currentItemSubject = BehaviorSubject<LoadingItem>();
  final _individualSchoolEnabledSubject = BehaviorSubject.seeded(false);

  Stream<double> get progressStream => _progressSubject.stream;

  Stream<List<LoadingItem>> get loadingErrorsStream =>
      _loadingErrorsSubject.stream;

  Stream<LoadingItem> get currentItemStream => _currentItemSubject.stream;

  Stream<bool> get individualSchoolEnabledStream =>
      _individualSchoolEnabledSubject.stream;

  CancelableOperation _downloadOp;

  DownloadDataDialogViewModel(
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
    _progressSubject.disposeWith(disposeBag);
    _loadingErrorsSubject.disposeWith(disposeBag);
    _currentItemSubject.disposeWith(disposeBag);
    _individualSchoolEnabledSubject.disposeWith(disposeBag);
  }

  @override
  void dispose() {
    super.dispose();
    _downloadOp?.cancel();
  }

  void onIndividualSchoolEnabledChanged(bool newValue) {
    _individualSchoolEnabledSubject.add(newValue);
  }

  void onDownloadPressed() {
    _downloadOp = CancelableOperation.fromFuture(
      Future.microtask(() async {
        Screen.keepOn(true);
        _progressSubject.add(0.01);
        final sectionsToLoad = await _getSectionsForEmis(
          await _globalSettings.currentEmis,
        );

        final needToLoadIndividualSchools = _individualSchoolEnabledSubject.value;
        if (!needToLoadIndividualSchools) {
          sectionsToLoad.remove(Section.individualSchools);
        }

        await _downloadLookups();
        _progressSubject.add(1 / (sectionsToLoad.length + 1));
        for (var i = 0; i < sectionsToLoad.length; i++) {
          final section = sectionsToLoad[i];
          await _loadSection(section);
          _progressSubject.add((i + 2) / (sectionsToLoad.length + 1));
        }

        Screen.keepOn(false);
      }),
    );
  }

  void onCancelPressed() {
    _downloadOp?.cancel();
    navigator.pop();
  }

  Future<void> _loadSection(Section section) {
    _currentItemSubject.add(LoadingItem(section));
    switch (section) {
      case Section.schools:
        return _downloadSchoolsEnrollmentData();
      case Section.teachers:
        return _downloadTeachersEnrollmentData();
      case Section.exams:
        return _downloadExamsData();
      case Section.schoolAccreditations:
        return _downloadAccreditationData();
      case Section.indicators:
        return Future.delayed(const Duration(seconds: 1));
      case Section.budgets:
        return _downloadBudgetsData();
      case Section.wash:
        return _downloadWashData();
      case Section.individualSchools:
        return _downloadIndividualSchoolData();
      case Section.specialEducation:
        return _downloadSpecialData();
    }
    throw FallThroughError();
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
      await _repository.lookups.first;
    } catch (t) {
      print(t);
      // _onSectionLoadingError(Section.schools);
    }
  }

  Future<void> _downloadSchoolsEnrollmentData() async {
    try {
      await _repository.fetchAllSchools().toList();
    } catch (t) {
      _onSectionLoadingError(Section.schools);
    }
  }

  Future<void> _downloadTeachersEnrollmentData() async {
    try {
      await _repository.fetchAllTeachers().toList();
    } catch (t) {
      _onSectionLoadingError(Section.teachers);
    }
  }

  Future<void> _downloadExamsData() async {
    try {
      await _repository.fetchAllExams().toList();
    } catch (t) {
      _onSectionLoadingError(Section.exams);
    }
  }

  Future<void> _downloadAccreditationData() async {
    try {
      await _repository.fetchAllAccreditations().toList();
    } catch (t) {
      _onSectionLoadingError(Section.schoolAccreditations);
    }
  }

  Future<void> _downloadBudgetsData() async {
    try {
      await _repository.fetchAllBudgets().toList();
    } catch (t) {
      _onSectionLoadingError(Section.budgets);
    }
  }

  Future<void> _downloadWashData() async {
    try {
      await _repository.fetchAllWashChunk().toList();
    } catch (t) {
      _onSectionLoadingError(Section.wash);
    }
  }

  Future<void> _downloadSpecialData() async {
    try {
      await _repository.fetchAllSpecialEducation().toList();
    } catch (t) {
      _onSectionLoadingError(Section.specialEducation);
    }
  }

  Future<void> _downloadIndividualSchoolData() async {
    try {
      final schools = (await _repository.fetchSchoolsList().toList()).last.data;
      for (final school in schools) {
        final id = school.id;
        final item = IndividualSchoolsLoadingItem(id);
        try {
          _currentItemSubject.add(item);
          await Future.wait([
            _repository.fetchIndividualSchool(id).toList(),
            _repository
                .fetchIndividualSchoolEnroll(id, school.districtCode)
                .toList(),
            _repository.fetchIndividualSchoolExams(id).toList(),
            _repository.fetchIndividualSchoolFlow(id).toList(),
          ]);
        } catch (t) {
          _loadingErrorsSubject.add(
            _loadingErrorsSubject.value..add(item),
          );
        }
      }
    } catch (t) {
      _onSectionLoadingError(Section.individualSchools);
    }
  }

  void _onSectionLoadingError(Section section) {
    _loadingErrorsSubject.add(
      _loadingErrorsSubject.value..add(LoadingItem(section)),
    );
  }
}

class LoadingItem {
  const LoadingItem(this.section);

  final Section section;

  String getName(BuildContext context) {
    return section.getName(context);
  }
}

class IndividualSchoolsLoadingItem extends LoadingItem {
  const IndividualSchoolsLoadingItem(this.schoolId)
      : super(Section.individualSchools);

  final String schoolId;

  @override
  String getName(BuildContext context) {
    return '${super.getName(context)} ($schoolId)';
  }
}
