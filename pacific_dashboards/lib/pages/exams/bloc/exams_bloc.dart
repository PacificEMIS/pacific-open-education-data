import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/exams/bloc/exams_navigator.dart';
import 'package:pacific_dashboards/pages/home/section.dart';
import './bloc.dart';

class ExamsBloc extends BaseBloc<ExamsEvent, ExamsState> {
  ExamsBloc({
    Repository repository,
    RemoteConfig remoteConfig,
    GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings;

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  ExamsNavigator _navigator;
  String _note;

  @override
  ExamsState get initialState => InitialExamsState();

  @override
  ExamsState get serverUnavailableState => ServerUnavailableState();

  @override
  ExamsState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookupsStream => _repository.lookups;

  @override
  Stream<ExamsState> mapEventToState(ExamsEvent event) async* {
    if (event is StartedExamsEvent) {
      final currentState = state;
      yield LoadingExamsState();
      _note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.exams)
          ?.note;
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllExams,
        onSuccess: (data) async* {
          _navigator = ExamsNavigator(data);
          yield PopulatedExamsState(await _convertExams(), _note);
          yield _filterState;
        },
      );
    }

    if (event is PrevExamSelectedEvent) {
      _navigator.prevExamPage();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }

    if (event is NextExamSelectedEvent) {
      _navigator.nextExamPage();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }

    if (event is PrevViewSelectedEvent) {
      _navigator.prevExamView();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }

    if (event is NextViewSelectedEvent) {
      _navigator.nextExamView();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }

    if (event is PrevFilterSelectedEvent) {
      _navigator.prevExamStandard();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }

    if (event is NextFilterSelectedEvent) {
      _navigator.nextExamStandard();
      yield PopulatedExamsState(await _convertExams(), _note);
      yield _filterState;
    }
  }

  PopulatedFilterState get _filterState => PopulatedFilterState(
        _navigator.pageName,
        _navigator.viewName,
        _navigator.standardName,
      );

  Future<BuiltMap<String, BuiltMap<String, Exam>>> _convertExams() {
    return lookups
        .then((lookups) => Future(() => _navigator.getExamResults(lookups)));
  }
}
