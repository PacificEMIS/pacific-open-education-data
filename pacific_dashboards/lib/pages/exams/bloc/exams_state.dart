import 'package:equatable/equatable.dart';

abstract class ExamsState extends Equatable {
  const ExamsState();

  @override
  List<Object> get props => [];
}

class InitialExamsState extends ExamsState {}

class LoadingExamsState extends ExamsState {}

class PopulatedExamsState extends ExamsState {
  final List<Object> items;
}
