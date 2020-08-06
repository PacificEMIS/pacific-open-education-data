import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends ViewModel {
  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;

  final Subject<Emis> _selectedEmisSubject = BehaviorSubject();
  final Subject<List<Section>> _sectionsSubject = BehaviorSubject();

  Stream<Emis> get selectedEmisStream => _selectedEmisSubject.stream;

  Stream<List<Section>> get sectionStream => _sectionsSubject.stream;

  HomeViewModel(
    BuildContext ctx, {
    @required GlobalSettings globalSettings,
    @required RemoteConfig remoteConfig,
  })  : assert(globalSettings != null),
        assert(remoteConfig != null),
        _globalSettings = globalSettings,
        _remoteConfig = remoteConfig,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _selectedEmisSubject.disposeWith(disposeBag);
    _sectionsSubject.disposeWith(disposeBag);
    _loadCurrentEmis();
  }

  void _loadCurrentEmis() {
    launchHandled(() async {
      final currentEmis = await _globalSettings.currentEmis;
      onEmisChanged(currentEmis);
    });
  }

  void _configureLanguageChanges(Emis currentEmis) {
    Strings.emis = currentEmis;
  }

  void onEmisChanged(Emis emis) {
    launchHandled(() async {
      _configureLanguageChanges(emis);
      _selectedEmisSubject.add(emis);
      _sectionsSubject.add(await _getSectionsForEmis(emis));
    });
  }

  Future<List<Section>> _getSectionsForEmis(Emis emis) async {
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
