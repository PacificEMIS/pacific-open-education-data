import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/exam_model.dart';

abstract class ExamsState extends Equatable {
  const ExamsState();

  @override
  List<Object> get props => [];
}

class InitialExamsState extends ExamsState {}

class LoadingExamsState extends ExamsState {}

class PopulatedExamsState extends ExamsState {
  const PopulatedExamsState(this.results);

  final Map<String, Map<String, ExamModel>> results;

  @override
  List<Object> get props => [results];
}
