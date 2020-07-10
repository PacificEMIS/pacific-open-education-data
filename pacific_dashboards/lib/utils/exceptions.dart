import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final String message;

  const AppException({@required this.message});
}

class RemoteException extends AppException {
  final int code;
  final String url;

  const RemoteException({
    @required this.code,
    @required String message,
    @required this.url,
  }) : super(message: message);
}

class NoNewDataRemoteException extends RemoteException {
  const NoNewDataRemoteException({@required String url})
      : super(
          code: 403,
          message: 'No new data',
          url: url,
        );
}

class NoInternetException extends RemoteException {
  const NoInternetException();
}

class NoDataException extends AppException {
  const NoDataException() : super(message: 'No Data');
}
