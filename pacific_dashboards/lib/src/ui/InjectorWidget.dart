import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/ServerBackendProvider.dart';
import '../resources/RepositoryImpl.dart';
import '../resources/Repository.dart';
import '../blocs/TeachersBloc.dart';
import '../blocs/SchoolsBloc.dart';
import '../resources/FileProviderImpl.dart';
import '../utils/GlobalSettings.dart';

// ignore: must_be_immutable
class InjectorWidget extends InheritedWidget {
  TeachersBloc _teachersBloc;
  SchoolsBloc _schoolsBloc;
  Repository _repository;
  SharedPreferences _sharedPreferences;
  GlobalSettings _globalSettings;

  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget) as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InjectorWidget old) => false;

  init() async {
    if (_sharedPreferences != null) {
      throw Exception("InjectorWidget::init sould be called only once");
    }

    _sharedPreferences = await SharedPreferences.getInstance();
    _repository = RepositoryImpl(ServerBackendProvider(), FileProviderImpl(_sharedPreferences));
    _teachersBloc = TeachersBloc(repository: _repository);
    _schoolsBloc = SchoolsBloc(repository: _repository);
    _globalSettings = GlobalSettings(_sharedPreferences);
  }

  TeachersBloc getTeachersBloc({bool forceCreate = false}) {
    if (_teachersBloc == null || _teachersBloc.fetcher.isClosed || forceCreate) {
      _teachersBloc = TeachersBloc(repository: _repository);
    }

    return _teachersBloc;
  }

  SchoolsBloc getSchoolsBloc({bool forceCreate = false}) {
    if (_schoolsBloc == null || _schoolsBloc.fetcher.isClosed || forceCreate) {
      _schoolsBloc = SchoolsBloc(repository: _repository);
    }

    return _schoolsBloc;
  }

  SharedPreferences getSharedPreferences() => _sharedPreferences;

  GlobalSettings getGlobalSettings() => _globalSettings;
}
