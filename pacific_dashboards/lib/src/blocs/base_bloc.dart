import 'package:meta/meta.dart';


abstract class BaseBloc<T> {
  @protected
  final repository;

  BaseBloc( {this.repository} );

  fetchData();

  dispose();
}
