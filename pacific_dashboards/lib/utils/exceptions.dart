import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';

class NoNewDataRemoteException extends RemoteException {
  const NoNewDataRemoteException({@required String url})
      : super(
          code: 403,
          message: 'No new data',
          url: url,
        );
}

class NoDataException extends AppException {
  const NoDataException() : super(message: 'labelNoData');
}

abstract class IWarning implements Exception {
  const IWarning([this.message]);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class Warning extends IWarning {
  const Warning([String message]) : super(message);
}
