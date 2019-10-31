import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const kDefaultCountry = "Federated States of Micronesia";
  static const _kCountryKey = "country";
  static const _kVersionSuffix = "_version";

  final SharedPreferences _sharedPreferences;

  GlobalSettings(this._sharedPreferences);

  String get currentCountry {
    return _sharedPreferences.getString(_kCountryKey) ?? kDefaultCountry;
  }

  set currentCountry(String country) {
    _sharedPreferences.setString(_kCountryKey, country);
  }

  String getEtag(String path) {
    return _sharedPreferences.getString(path + _kVersionSuffix);
  }

  void setEtag(String path, String etag) {
    _sharedPreferences.setString(path + _kVersionSuffix, etag);
  }
}
