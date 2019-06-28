import 'package:meta/meta.dart';

import '../resources/Repository.dart';

abstract class BaseBloc<T> {
  @protected
  final Repository repository;

  BaseBloc( {this.repository} );

  dispose();
}
