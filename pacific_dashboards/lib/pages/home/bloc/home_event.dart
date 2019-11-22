import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/emis.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StartedHomeEvent extends HomeEvent {}

class EmisChanged extends HomeEvent {
  const EmisChanged(this.emis);
  
  final Emis emis;

  @override
  List<Object> get props => [emis];
}
