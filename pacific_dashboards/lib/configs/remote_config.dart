import 'package:built_collection/built_collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart'
    as fireConfig;
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
    return Future.microtask(() {
      final remote = _remoteConfig.getString(_kConfigName);
      return EmisesConfig.fromJson(remote);
    });
  }
}

EmisesConfig _defaultConfig = EmisesConfig(
  (b) => b
    ..emises = ListBuilder<EmisConfig>([
      EmisConfig(
        (b) => b
          ..id = 'miemis'
          ..modules = ListBuilder<ModuleConfig>([
            ModuleConfig((b) => b..id = 'schools'),
            ModuleConfig((b) => b..id = 'teachers'),
            ModuleConfig((b) => b..id = 'exams'),
            ModuleConfig((b) => b..id = 's_accreditation'),
          ]),
      ),
      EmisConfig(
        (b) => b
          ..id = 'fedemis'
          ..modules = ListBuilder<ModuleConfig>([
            ModuleConfig((b) => b..id = 'schools'),
            ModuleConfig((b) => b..id = 'teachers'),
            ModuleConfig((b) => b..id = 'exams'),
            ModuleConfig((b) => b..id = 's_accreditation'),
          ]),
      ),
      EmisConfig(
        (b) => b
          ..id = 'kemis'
          ..modules = ListBuilder<ModuleConfig>([
            ModuleConfig((b) => b..id = 'schools'),
            ModuleConfig((b) => b..id = 'teachers'),
            ModuleConfig((b) => b..id = 'exams'),
          ]),
      ),
    ]),
);
