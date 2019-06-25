import 'package:flutter/material.dart';

import '../blocs/teachers_bloc.dart';

class InjectorWidget extends InheritedWidget {
  TeachersBloc _teachersBloc;

  TeachersBloc getTeachersBloc() => _teachersBloc;

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
    _teachersBloc = TeachersBloc();
  }

  TeachersBloc getForceTeachersBloc({bool forceCreate = false}) {
    if (_teachersBloc == null || forceCreate) {
      _teachersBloc = TeachersBloc();
    }

    return _teachersBloc;
  }
}
