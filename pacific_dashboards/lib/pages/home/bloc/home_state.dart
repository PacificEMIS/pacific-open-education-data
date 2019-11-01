import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/emis.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class LoadedHomeState extends HomeState {
  const LoadedHomeState(this.emis);

  final Emis emis;

  @override
  List<Object> get props => [emis];
}

class LoadingHomeState extends HomeState {
  @override
  List<Object> get props => [];
}
