import 'package:meta/meta.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';

abstract class BaseBloc<T> {
  @protected
  final Repository repository;

  BaseBloc({this.repository});

  dispose();
}
