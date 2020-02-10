import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
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
  PopulatedExamsState(this.results, this.note);

  final BuiltMap<String, BuiltMap<String, Exam>> results;
  final String note;

  @override
  List<Object> get props => [
        results,
        note,
      ];
}

class PopulatedFilterState extends FilterState {
  PopulatedFilterState(this.examName, this.viewName, this.standardName);

  final String examName;
  final String viewName;
  final String standardName;

  @override
  List<Object> get props => [examName, viewName, standardName];
}
