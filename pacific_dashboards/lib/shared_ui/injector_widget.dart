import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/global_settings.dart';
import 'package:pacific_dashboards/data/local/file_provider_impl.dart';
import 'package:pacific_dashboards/data/remote/backend_provider.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/data/repository_impl.dart';
import 'package:pacific_dashboards/pages/exams/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/home/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/school_accreditation/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/teachers/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InjectorWidget extends InheritedWidget {
  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

  Repository _repository;
  SharedPreferences _sharedPreferences;
  GlobalSettings _globalSettings;

  @override
  bool updateShouldNotify(InjectorWidget old) => false;

  init() async {
    if (_sharedPreferences != null) {
      throw Exception("InjectorWidget::init sould be called only once");
    }

    _sharedPreferences = await SharedPreferences.getInstance();
    _globalSettings = GlobalSettings(_sharedPreferences);

    _repository = RepositoryImpl(
        ServerBackendProvider(_globalSettings),
        FileProviderImpl(_sharedPreferences, _globalSettings),
        _sharedPreferences);
  }

  SchoolsBloc get schoolsBloc => SchoolsBloc(repository: _repository);

  TeachersBloc get teachersBloc => TeachersBloc(repository: _repository);

  ExamsBloc get examsBloc => ExamsBloc(repository: _repository);

  AccreditationBloc get schoolAccreditationsBloc => AccreditationBloc(repository: _repository);

  HomeBloc get homeBloc => HomeBloc(globalSettings: _globalSettings);

  SharedPreferences get sharedPreferences => _sharedPreferences;

  GlobalSettings get globalSettings => _globalSettings;
}
