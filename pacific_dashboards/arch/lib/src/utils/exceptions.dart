import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final String message;

  const AppException({@required this.message}) : assert(message != null);
}

class NoInternetException extends AppException {
  const NoInternetException() : super(message: 'No Internet connection');
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

class UnknownRemoteException extends RemoteException {
  const UnknownRemoteException({@required String url})
      : super(code: 0, message: 'Unknown server error', url: url);
}

class UnauthorizedRemoteException extends RemoteException {
  const UnauthorizedRemoteException({
    @required int code,
    @required String message,
    @required String url,
  }) : super(code: code, message: message, url: url);
}


class WrongCredentialsRemoteException extends RemoteException {
  const WrongCredentialsRemoteException({
    @required int code,
    @required String message,
    @required String url,
  }) : super(code: code, message: message, url: url);
}
