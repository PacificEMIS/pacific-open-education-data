import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/local/file_provider_impl.dart';
import 'package:pacific_dashboards/data/local/storages/key_string_storage.dart';
import 'package:pacific_dashboards/data/remote/backend_provider.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/data/repository_impl.dart';
import 'package:pacific_dashboards/pages/exams/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/home/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/school_accreditation/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/teachers/bloc/bloc.dart';

// ignore: must_be_immutable
class InjectorWidget extends InheritedWidget {
  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InjectorWidget>();
  }

  Repository _repository;
  GlobalSettings _globalSettings;
  RemoteConfig _remoteConfig;

  @override
  bool updateShouldNotify(InjectorWidget old) => false;

  init() async {
    final stringsStorage = HiveKeyStringStorage();
    await stringsStorage.init();

    _globalSettings = GlobalSettings(stringsStorage);

    _repository = RepositoryImpl(
      ServerBackendProvider(_globalSettings),
      FileProviderImpl(stringsStorage, _globalSettings),
    );

    final fireRemoteConfig = FirebaseRemoteConfig();
    _remoteConfig = fireRemoteConfig;
    await fireRemoteConfig.init();
  }

  SchoolsBloc get schoolsBloc => SchoolsBloc(repository: _repository);

  TeachersBloc get teachersBloc => TeachersBloc(repository: _repository);

  ExamsBloc get examsBloc => ExamsBloc(repository: _repository);

  AccreditationBloc get schoolAccreditationsBloc =>
      AccreditationBloc(repository: _repository);

  HomeBloc get homeBloc =>
      HomeBloc(globalSettings: _globalSettings, remoteConfig: _remoteConfig);

  GlobalSettings get globalSettings => _globalSettings;
}
