import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends ViewModel {

  BaseViewModel(BuildContext ctx) : super(ctx);


  @override
  @protected
  void handleAppException(AppException appException) {
    if (appException is NoInternetException) {
      notifyErrorMessage('error_server_unavailable');
    } else {
      notifyErrorMessage('error_unknown');
    }
  }

  @protected
  Stream<T> handleRepositoryFetch<T>({
    @required Stream<RepositoryResponse<T>> fetch(),
  }) async* {
    try {
      final fetchStream = fetch();
      var isCacheEmpty = false;
      await for (var response in fetchStream) {
        if (response is SuccessRepositoryResponse) {
          yield response.data;
        } else if (response is FailureRepositoryResponse) {
          switch (response.type) {
            case RepositoryType.local:
              isCacheEmpty = true;
              break;
            case RepositoryType.remote:
              if (isCacheEmpty) {
                throw response.throwable;
              }
              break;
          }
        }
      }
    } catch (ex) {
      handleThrows(ex);
    }
  }

}