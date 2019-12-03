import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';

abstract class ExamsState extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class BodyState extends ExamsState {}

abstract class FilterState extends ExamsState {}

class InitialExamsState extends BodyState implements FilterState {}

class ServerUnavailableState extends ExamsState implements ErrorState {}

class UnknownErrorState extends ExamsState implements ErrorState {}

class LoadingExamsState extends BodyState {}

class PopulatedExamsState extends BodyState {
  PopulatedExamsState(this.results);

  final Map<String, Map<String, ExamModel>> results;

  @override
  List<Object> get props => [results];
}

class PopulatedFilterState extends FilterState {
  PopulatedFilterState(this.examName, this.viewName, this.standardName);

  final String examName;
  final String viewName;
  final String standardName;

  @override
  List<Object> get props => [examName, viewName, standardName];
}
