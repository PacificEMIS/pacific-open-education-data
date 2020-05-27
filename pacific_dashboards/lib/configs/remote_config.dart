import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart' as fireConfig;
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/emis_config/emises_config.dart';
import 'package:pacific_dashboards/models/emis_config/module_config.dart';

abstract class RemoteConfig {
  Future<EmisesConfig> get emises;
}

class FirebaseRemoteConfig extends RemoteConfig {
  static const _kConfigName = 'app_config';

  fireConfig.RemoteConfig _remoteConfig;

  Future<void> init() async {
    _remoteConfig = await fireConfig.RemoteConfig.instance;
    final defaultConfig = _defaultConfig.toJson();
    await _remoteConfig.setDefaults({_kConfigName: defaultConfig});

    await _remoteConfig.fetch(expiration: const Duration(hours: 5));
    await _remoteConfig.activateFetched();
  }

  @override
  Future<EmisesConfig> get emises async {
    final remoteConfigString = _remoteConfig.getString(_kConfigName);
    return compute(_parseEmisesConfig, remoteConfigString);
  }

  static EmisesConfig _parseEmisesConfig(String jsonConfig) {
    final parsedJson = json.decode(jsonConfig);
    return EmisesConfig.fromJson(parsedJson);
  }
}

EmisesConfig _defaultConfig = EmisesConfig(
  [
    EmisConfig(
      id: 'miemis',
      modules: [
        ModuleConfig(id: 'schools'),
        ModuleConfig(id: 'teachers'),
        ModuleConfig(id: 'exams'),
        ModuleConfig(id: 's_accreditation'),
      ],
    ),
    EmisConfig(
      id: 'fedemis',
      modules: [
        ModuleConfig(id: 'schools'),
        ModuleConfig(id: 'teachers'),
        ModuleConfig(id: 'exams'),
        ModuleConfig(id: 's_accreditation'),
      ],
    ),
    EmisConfig(
      id: 'kemis',
      modules: [
        ModuleConfig(id: 'schools'),
        ModuleConfig(id: 'teachers'),
        ModuleConfig(id: 'exams'),
      ],
    ),
  ],
);
