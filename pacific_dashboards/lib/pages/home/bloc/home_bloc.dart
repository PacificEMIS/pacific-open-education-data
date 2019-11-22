import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/global_settings.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({@required GlobalSettings globalSettings})
      : assert(globalSettings != null),
        _globalSettings = globalSettings;

  final GlobalSettings _globalSettings;

  @override
  HomeState get initialState => LoadingHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is StartedHomeEvent) {
      final currentEmis = _globalSettings.currentEmis;
      yield LoadedHomeState(currentEmis);
    }

    if (event is EmisChanged) {
      final emis = event.emis;
      await _globalSettings.setCurrentEmis(emis);
      yield LoadedHomeState(emis);
    }
  }
}
