import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/global_settings.dart';
import 'package:pacific_dashboards/data/local/file_provider_impl.dart';
import 'package:pacific_dashboards/data/remote/backend_provider.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/data/repository_impl.dart';
import 'package:pacific_dashboards/pages/exams/exams_bloc.dart';
import 'package:pacific_dashboards/pages/home/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_bloc.dart';
import 'package:pacific_dashboards/pages/schools/schools_bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InjectorWidget extends InheritedWidget {
  TeachersBloc _teachersBloc;
  SchoolsBloc _schoolsBloc;
  ExamsBloc _examsBloc;
  SchoolAccreditationBloc _schoolAccreditationBloc;
  Repository _repository;
  SharedPreferences _sharedPreferences;
  GlobalSettings _globalSettings;

  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

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

  TeachersBloc get teachersBloc {
    if (_teachersBloc == null) {
      _teachersBloc = TeachersBloc(repository: _repository);
    }

    return _teachersBloc;
  }

  SchoolsBloc get schoolsBloc {
    if (_schoolsBloc == null) {
      _schoolsBloc = SchoolsBloc(repository: _repository);
    }

    return _schoolsBloc;
  }

  ExamsBloc get examsBloc {
    if (_examsBloc == null) {
      _examsBloc = ExamsBloc(repository: _repository);
    }

    return _examsBloc;
  }

  SchoolAccreditationBloc get schoolAccreditationsBloc {
    if (_schoolAccreditationBloc == null) {
      _schoolAccreditationBloc =
          SchoolAccreditationBloc(repository: _repository);
    }

    return _schoolAccreditationBloc;
  }

  HomeBloc get homeBloc => HomeBloc(globalSettings: _globalSettings);

  SharedPreferences get sharedPreferences => _sharedPreferences;

  GlobalSettings get globalSettings => _globalSettings;
}
