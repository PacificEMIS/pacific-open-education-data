import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/pages/home/section.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    @required GlobalSettings globalSettings,
    @required RemoteConfig remoteConfig,
  })  : assert(globalSettings != null),
        assert(remoteConfig != null),
        _globalSettings = globalSettings,
        _remoteConfig = remoteConfig;

  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;

  @override
  HomeState get initialState => LoadingHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is StartedHomeEvent) {
      final currentEmis = await _globalSettings.currentEmis;
      if (currentEmis == Emis.kemis) {
        AppLocalizations.load(Locale('zh'));
      } else {
        AppLocalizations.load(Locale('en'));
      }
      yield LoadedHomeState(
          currentEmis, await configureSectionsForEmis(currentEmis));
    }

    if (event is EmisChanged) {
      if (event.emis == Emis.kemis) {
        AppLocalizations.load(Locale('zh'));
      } else {
        AppLocalizations.load(Locale('en'));
      }
      final emis = event.emis;
      await _globalSettings.setCurrentEmis(emis);
      yield LoadedHomeState(emis, await configureSectionsForEmis(emis));
    }
  }

  Future<List<Section>> configureSectionsForEmis(Emis emis) async {
    final emisesConfig = await _remoteConfig.emises;

    EmisConfig emisConfig = emisesConfig.getEmisConfigFor(emis);
    if (emisConfig == null) {
      return [];
    }

    return emisConfig.modules
        .map((config) => config.asSection())
        .where((it) => it != null)
        .toList();
  }
}
