class DataNotLoadedException implements Exception {
  final String _apiKey;

  DataNotLoadedException(this._apiKey);

  String toString() {
    return "Error! Data not loaded from api: $_apiKey";
  }
}