import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

abstract class BaseBloc<T> {
  @protected
  final repository = Repository();

  @protected
  final fetcher = PublishSubject<T>();

  Observable<T> get data => fetcher.stream;

  fetchData();

  dispose() {
    fetcher.close();
  }
}
