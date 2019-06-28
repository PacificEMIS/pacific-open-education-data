import 'package:flutter/material.dart';
import '../resources/ServerBackendProvider.dart';
import '../resources/RepositoryImpl.dart';
import '../resources/repository.dart';
import '../blocs/TeachersBloc.dart';
import '../resources/FileProviderImpl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InjectorWidget extends InheritedWidget {
  TeachersBloc _teachersBloc;
  Repository _repository;
  SharedPreferences _sharedPreferences;

  InjectorWidget({
    Key key,
    @required Widget child,
  })
      : assert(child != null),
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
  }

  TeachersBloc getTeachersBloc({bool forceCreate = false}) {
    if (_teachersBloc == null || forceCreate) {
      _teachersBloc = TeachersBloc(repository: _repository);
    }

    return _teachersBloc;
  }
}
