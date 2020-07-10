import 'dart:async';

import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ViewModel {
  final DisposeBag disposeBag = DisposeBag();

  @protected
  final BehaviorSubject<bool> activityIndicatorSubject =
      BehaviorSubject.seeded(false);

  @protected
  final PublishSubject<String> errorMessagesSubject = PublishSubject();

  void onInit() {
    activityIndicatorSubject.disposeWith(disposeBag);
    errorMessagesSubject.disposeWith(disposeBag);
  }

  @mustCallSuper
  void dispose() {
    disposeBag.dispose();
  }

  Stream<bool> get activityIndicatorStream => activityIndicatorSubject.stream;

  Stream<String> get errorMessagesStream => errorMessagesSubject.stream;

  @protected
  void notifyHaveProgress(bool haveProgress) {
    activityIndicatorSubject.add(haveProgress);
  }

  @protected
  void handleThrows(Object thrownObject) {
    if (thrownObject is Error) {
      errorMessagesSubject.add(thrownObject.toString());
    } else if (thrownObject is Exception) {
      if (thrownObject is AppException) {
        handleAppException(thrownObject);
      } else {
        errorMessagesSubject.add(thrownObject.toString());
      }
    } else {
      throw thrownObject;
    }
  }

  @protected
  void handleAppException(AppException exception) {
    errorMessagesSubject.add(exception.message);
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
