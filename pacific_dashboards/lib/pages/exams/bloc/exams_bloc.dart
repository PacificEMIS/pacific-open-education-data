import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/exams/bloc/exams_navigator.dart';
import './bloc.dart';

class ExamsBloc extends BaseBloc<ExamsEvent, ExamsState> {
  ExamsBloc({@required Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;

  ExamsNavigator _navigator;

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
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllExams,
        onSuccess: (data) async* {
          _navigator = ExamsNavigator(data);
          yield PopulatedExamsState(await _convertExams());
          yield _filterState;
        },
      );
    }

    if (event is PrevExamSelectedEvent) {
      _navigator.prevExamPage();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextExamSelectedEvent) {
      _navigator.nextExamPage();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is PrevViewSelectedEvent) {
      _navigator.prevExamView();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextViewSelectedEvent) {
      _navigator.nextExamView();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is PrevFilterSelectedEvent) {
      _navigator.prevExamStandard();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextFilterSelectedEvent) {
      _navigator.nextExamStandard();
      yield PopulatedExamsState(await _convertExams());
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
