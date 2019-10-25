class ApiException implements Exception {
  final String apiKey;
  final int code;

  ApiException(this.apiKey, this.code);

  String toString() {
    return "ApiException: $apiKey respond with code:$code";
  }
}

class NoNewRemoteDataException implements Exception {

  NoNewRemoteDataException();

  String toString() {
    return "NoNewRemoteDataException";
  }
}
