import 'dart:async';

import 'package:arch/src/utils/dispose_bag.dart';
import 'package:arch/src/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class ViewModel {
  final DisposeBag disposeBag = DisposeBag();

  final BehaviorSubject<bool> _activityIndicatorSubject =
      BehaviorSubject.seeded(false);

  final PublishSubject<String> _errorMessagesSubject = PublishSubject();

  final Subject<bool> _needToShowBlockingLoadingSubject =
      BehaviorSubject.seeded(false);

  @protected
  final NavigatorState navigator;

  ViewModel(BuildContext ctx) : navigator = Navigator.of(ctx);

  Stream<bool> get activityIndicatorStream => _activityIndicatorSubject.stream;

  Stream<bool> get needToShowBlockingLoadingStream =>
      _needToShowBlockingLoadingSubject.stream;

  Stream<String> get errorMessagesStream => _errorMessagesSubject.stream;

  @mustCallSuper
  void onInit() {
    _activityIndicatorSubject.disposeWith(disposeBag);
    _errorMessagesSubject.disposeWith(disposeBag);
    _needToShowBlockingLoadingSubject.disposeWith(disposeBag);
  }

  @mustCallSuper
  void dispose() {
    disposeBag.dispose();
  }

  @protected
  void notifyHaveProgress(bool haveProgress) {
    _activityIndicatorSubject.add(haveProgress);
  }

  @protected
  void notifyHaveBlockingProgress(bool haveProgress) {
    _needToShowBlockingLoadingSubject.add(haveProgress);
  }

  @protected
  void notifyErrorMessage(String message) {
    _errorMessagesSubject.add(message);
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
    bool notifyBlockingProgress = false,
  }) {
    return Future(() async {
      if (notifyProgress) {
        notifyHaveProgress(true);
      }
      if (notifyBlockingProgress) {
        notifyHaveBlockingProgress(true);
      }
      try {
        await perform();
      } catch (o) {
        handleThrows(o);
      } finally {
        if (notifyProgress) {
          notifyHaveProgress(false);
        }
        if (notifyBlockingProgress) {
          notifyHaveBlockingProgress(false);
        }
      }
    });
  }

  void listenHandled<T>(
    Stream<T> stream,
    FutureOr<void> onData(T event), {
    bool notifyProgress = false,
    bool notifyBlockingProgress = false,
    bool cancelOnError = false,
  }) {
    stream.doOnListen(() {
      if (notifyProgress) {
        notifyHaveProgress(true);
      }
      if (notifyBlockingProgress) {
        notifyHaveBlockingProgress(true);
      }
    }).listen(
      (event) {
        launchHandled(() async {
          await onData.call(event);
          if (notifyProgress) {
            notifyHaveProgress(false);
          }
          if (notifyBlockingProgress) {
            notifyHaveBlockingProgress(false);
          }
        });
      },
      onError: (t) {
        handleThrows(t);
        if (notifyProgress) {
          notifyHaveProgress(false);
        }
        if (notifyBlockingProgress) {
          notifyHaveBlockingProgress(false);
        }
      },
      cancelOnError: cancelOnError,
    ).disposeWith(disposeBag);
  }
}
