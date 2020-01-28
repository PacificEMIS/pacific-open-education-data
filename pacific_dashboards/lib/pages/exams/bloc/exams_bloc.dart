import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import './bloc.dart';

class ExamsBloc extends BaseBloc<ExamsEvent, ExamsState> {
  ExamsBloc({@required Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;
  ExamsModel _examsModel;

  @override
  ExamsState get initialState => InitialExamsState();

  @override
  ExamsState get serverUnavailableState => ServerUnavailableState();

  @override
  ExamsState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookups => _repository.lookups;

  @override
  Stream<ExamsState> mapEventToState(ExamsEvent event) async* {
    if (event is StartedExamsEvent) {
      final currentState = state;
      yield LoadingExamsState();
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllExams,
        onSuccess: (data) async* {
          _examsModel = data;
          yield PopulatedExamsState(await _convertExams());
          yield _filterState;
        },
      );
    }

    if (event is PrevExamSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamPage();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextExamSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamPage();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is PrevViewSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamView();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextViewSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamView();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is PrevFilterSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamStandard();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }

    if (event is NextFilterSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamStandard();
      yield PopulatedExamsState(await _convertExams());
      yield _filterState;
    }
  }

  PopulatedFilterState get _filterState => PopulatedFilterState(
        _examsModel.examsDataNavigator.getExamPageName(),
        _examsModel.examsDataNavigator.getExamViewName(),
        _examsModel.examsDataNavigator.getStandardName(),
      );

  Future<Map<String, Map<String, ExamModel>>> _convertExams() {
    return Future(() => _examsModel.examsDataNavigator.getExamResults());
  }
}
