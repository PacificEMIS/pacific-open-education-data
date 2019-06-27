import 'package:flutter/material.dart';

import '../resources/repository_impl.dart';
import '../resources/repository.dart';
import '../blocs/teachers_bloc.dart';

class InjectorWidget extends InheritedWidget {
  TeachersBloc _teachersBloc;
  Repository _repository;

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
    _repository = RepositoryImpl();
    _teachersBloc = TeachersBloc(repository: _repository);
  }

  TeachersBloc getTeachersBloc({bool forceCreate = false}) {
    if (_teachersBloc == null || forceCreate) {
      _teachersBloc = TeachersBloc(repository: _repository);
    }

    return _teachersBloc;
  }
}
