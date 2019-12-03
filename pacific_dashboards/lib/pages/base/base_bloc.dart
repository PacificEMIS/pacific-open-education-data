import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  @protected
  State get serverUnavailableState;
  @protected
  State get unknownErrorState;

  @protected
  Stream<State> handleFetch<T>({
    @required State beforeFetchState,
    @required Stream<RepositoryResponse<T>> fetch(),
    @required Stream<State> onSuccess(T data),
  }) async* {
    Stream<State> passStatesOnError(State errorState) async* {
      yield beforeFetchState;
      yield errorState;
    }

    try {
      final fetchStream = fetch();
      var isCacheEmpty = false;
      await for (var response in fetchStream) {
        if (response is SuccessRepositoryResponse) {
          yield* onSuccess(response.data);
        } else if (response is FailureRepositoryResponse) {
          switch (response.type) {
            case RepositoryType.local:
              isCacheEmpty = true;
              break;
            case RepositoryType.remote:
              if (isCacheEmpty) {
                if (response.exception is UnavailableRemoteException) {
                  yield* passStatesOnError(serverUnavailableState);
                } else {
                  yield* passStatesOnError(unknownErrorState);
                }
              }
              break;
          }
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
      yield* passStatesOnError(unknownErrorState);
    }
  }
}

class ErrorState {}
