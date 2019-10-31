import 'package:meta/meta.dart';
import 'package:pacific_dashboards/resources/Repository.dart';

abstract class BaseBloc<T> {
  @protected
  final Repository repository;

  BaseBloc({this.repository});

  dispose();
}
