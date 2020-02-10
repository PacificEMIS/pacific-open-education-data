abstract class RemoteException implements Exception {}

class NoNewDataRemoteException implements RemoteException {
  const NoNewDataRemoteException();
}

class UnavailableRemoteException implements RemoteException {
  const UnavailableRemoteException();
}

class ApiRemoteException implements RemoteException {
  const ApiRemoteException({this.url, this.code, this.message});

  final int code;
  final String message;
  final String url;
}

class NoDataException implements Exception {}
