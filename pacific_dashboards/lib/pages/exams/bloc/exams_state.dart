import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';

abstract class ExamsState extends Equatable {
  const ExamsState();

  @override
  List<Object> get props => [];
}

class InitialExamsState extends ExamsState {}

class ServerUnavailableState extends ExamsState implements ErrorState {}

class UnknownErrorState extends ExamsState implements ErrorState {}

class LoadingExamsState extends ExamsState {}

class PopulatedExamsState extends ExamsState {
  const PopulatedExamsState(this.results);

  final Map<String, Map<String, ExamModel>> results;

  @override
  List<Object> get props => [results];
}
