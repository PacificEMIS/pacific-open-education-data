import 'package:get_it/get_it.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source_impl.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source_impl.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/db_impl/hive_database.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/data/repository/repository_impl.dart';

final ServiceLocator serviceLocator = GetItServiceLocator();

abstract class ServiceLocator {
  Future<void> prepare();

  Database get database;
  RemoteConfig get remoteConfig;
  GlobalSettings get globalSettings;
  Repository get repository;
}

class GetItServiceLocator extends ServiceLocator {

  final _getIt = GetIt.instance;

  @override
  Future<void> prepare() async {
    final database = HiveDatabase();
    await database.init();
    _getIt.registerSingleton<Database>(database);

    final fireRemoteConfig = FirebaseRemoteConfig();
    await fireRemoteConfig.init();
    _getIt.registerSingleton<RemoteConfig>(fireRemoteConfig);

    final globalSettings = GlobalSettings(database.strings);
    _getIt.registerSingleton<GlobalSettings>(globalSettings);

    final repository = RepositoryImpl(
      RemoteDataSourceImpl(globalSettings),
      LocalDataSourceImpl(database, globalSettings),
      globalSettings,
    );
    _getIt.registerSingleton<Repository>(repository);
  }

  @override
  Database get database => _getIt.get<Database>();

  @override
  RemoteConfig get remoteConfig => _getIt.get<RemoteConfig>();

  @override
  GlobalSettings get globalSettings => _getIt.get<GlobalSettings>();

  @override
  Repository get repository => _getIt.get<Repository>();

}