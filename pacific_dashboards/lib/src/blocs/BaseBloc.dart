import 'package:meta/meta.dart';

import '../resources/repository.dart';

abstract class BaseBloc<T> {
  @protected
  final Repository repository;

  BaseBloc( {this.repository} );

  dispose();
}
