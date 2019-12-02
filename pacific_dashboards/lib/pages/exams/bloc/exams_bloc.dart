import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import './bloc.dart';

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  ExamsBloc({@required Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;
  ExamsModel _examsModel;

  @override
  ExamsState get initialState => InitialExamsState();

  @override
  Stream<ExamsState> mapEventToState(ExamsEvent event) async* {
    if (event is StartedExamsEvent) {
      yield LoadingExamsState();
      _examsModel = await _repository.fetchAllExams();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is PrevExamSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamPage();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is NextExamSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamPage();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is PrevViewSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamView();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is NextViewSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamView();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is PrevFilterSelectedEvent) {
      _examsModel.examsDataNavigator.prevExamStandard();
      yield PopulatedExamsState(await _convertExams());
    }

    if (event is NextFilterSelectedEvent) {
      _examsModel.examsDataNavigator.nextExamStandard();
      yield PopulatedExamsState(await _convertExams());
    }
  }

  Future<Map<String, Map<String, ExamModel>>> _convertExams() {
    return Future(() => _examsModel.examsDataNavigator.getExamResults()); 
  }
}
