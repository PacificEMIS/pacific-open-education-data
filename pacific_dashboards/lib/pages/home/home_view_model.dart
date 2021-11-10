import 'dart:developer';
import 'dart:io';

import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/requireUpdate.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends ViewModel {
  final GlobalSettings _globalSettings;
  final RemoteConfig _remoteConfig;

  final Subject<Emis> _selectedEmisSubject = BehaviorSubject();
  final Subject<List<Section>> _sectionsSubject = BehaviorSubject();
  final Subject<RequireUpdate> _requireUpdateSubject = BehaviorSubject();

  Stream<Emis> get selectedEmisStream => _selectedEmisSubject.stream;

  Stream<List<Section>> get sectionStream => _sectionsSubject.stream;

  Stream<RequireUpdate> get requireUpdateStream => _requireUpdateSubject.stream;

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
      _checkUpdate();
      onEmisChanged(currentEmis);
    });
  }

  void _configureLanguageChanges(Emis currentEmis) {
    Strings.emis = currentEmis;
  }

  void onEmisChanged(Emis emis) {
    _globalSettings.setCurrentEmis(emis);
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

  Future<void> _checkUpdate() async {
    final emisesConfig = await _remoteConfig.emises;
    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on Exception {
      projectVersion = '';
    }
    log(emisesConfig.appVersion);
    log(projectVersion);
    showUpdate(_versionFromString(emisesConfig.appVersion) <
        _versionFromString(projectVersion)
        ? RequireUpdate.showPopup
        : RequireUpdate.no);
  }
  
  int _versionFromString(String versionString) {
    var versionNumbers = versionString.split(".");
    int result = 0;
    versionNumbers.forEach((String number) {
      result *= 100;
      result += int.parse(number);
    });
    return result;
  }

  void showUpdate(RequireUpdate requireUpdate) async {
    _requireUpdateSubject.add(requireUpdate);
  }

  void openStorePage() async {
    launch(
        Platform.isIOS
            ?
        'https://apps.apple.com/us/app/pacific-open-education-data/id1487072947?app=itunes&ign-mpt=uo%3D4'
            :
        'https://play.google.com/store/apps/details?id=org.pacific_emis.opendata&hl=en_US&gl=US');
  }
}
