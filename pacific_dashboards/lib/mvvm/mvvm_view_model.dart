import 'dart:async';

import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ViewModel {
  final DisposeBag disposeBag = DisposeBag();

  // ignore: close_sinks
  final BehaviorSubject<bool> _activityIndicatorSubject =
      BehaviorSubject.seeded(false);

  // ignore: close_sinks
  final PublishSubject<String> _errorMessagesSubject = PublishSubject();

  void onInit() {
    _activityIndicatorSubject.disposeWith(disposeBag);
    _errorMessagesSubject.disposeWith(disposeBag);
  }

  @mustCallSuper
  void dispose() {
    disposeBag.dispose();
  }

  Stream<bool> get activityIndicatorStream => _activityIndicatorSubject.stream;

  Stream<String> get errorMessagesStream => _errorMessagesSubject.stream;

  @protected
  void notifyHaveProgress(bool haveProgress) {
    _activityIndicatorSubject.add(haveProgress);
  }

  @protected
  void handleThrows(Object thrownObject) {
    if (thrownObject is Error) {
      _errorMessagesSubject.add(thrownObject.toString());
    } else if (thrownObject is Exception) {
      if (thrownObject is AppException) {
        handleAppException(thrownObject);
      } else {
        _errorMessagesSubject.add(thrownObject.toString());
      }
    } else {
      throw thrownObject;
    }
  }

  @protected
  void handleAppException(AppException exception) {
    _errorMessagesSubject.add(exception.message);
  }

  @protected
  Future<void> launchHandled<T>(
    FutureOr<T> perform(), {
    bool notifyProgress = false,
  }) {
    return Future(() async {
      if (notifyProgress) {
        notifyHaveProgress(true);
      }
      try {
        await perform();
      } catch (o) {
        handleThrows(o);
      } finally {
        if (notifyProgress) {
          notifyHaveProgress(false);
        }
      }
    });
  }
}
