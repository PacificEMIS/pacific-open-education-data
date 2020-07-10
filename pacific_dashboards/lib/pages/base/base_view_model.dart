import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

abstract class BaseViewModel extends ViewModel {

  @override
  @protected
  void handleAppException(AppException appException) {
    if (appException is NoInternetException) {
      errorMessagesSubject.add(AppLocalizations.serverUnavailableError);
    } else {
      errorMessagesSubject.add(AppLocalizations.unknownError);
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
                throw response.exception;
              }
              break;
          }
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
      rethrow;
    }
  }

}