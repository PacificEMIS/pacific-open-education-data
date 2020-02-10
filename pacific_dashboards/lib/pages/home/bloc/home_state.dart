import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/home/section.dart';


abstract class HomeState extends Equatable {
  const HomeState();
}

class LoadedHomeState extends HomeState {

  final Emis emis;
  final List<Section> sections;

  LoadedHomeState(this.emis, this.sections);

  @override
  List<Object> get props => [emis, sections];
}

class LoadingHomeState extends HomeState {
  @override
  List<Object> get props => [];
}
