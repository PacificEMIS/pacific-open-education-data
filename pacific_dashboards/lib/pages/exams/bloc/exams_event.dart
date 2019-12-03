import 'package:equatable/equatable.dart';

abstract class ExamsEvent extends Equatable {
  const ExamsEvent();

  @override
  List<Object> get props => [];
}

class StartedExamsEvent extends ExamsEvent {}

class PrevExamSelectedEvent extends ExamsEvent {}

class NextExamSelectedEvent extends ExamsEvent {}

class PrevViewSelectedEvent extends ExamsEvent {}

class NextViewSelectedEvent extends ExamsEvent {}

class PrevFilterSelectedEvent extends ExamsEvent {}

class NextFilterSelectedEvent extends ExamsEvent {}
