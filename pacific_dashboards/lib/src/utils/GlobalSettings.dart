import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const String _kCountryKey = "country";
  static const String _kDefaultCountry = "Federated States of Micronesia";
  final SharedPreferences _sharedPreferences;

  GlobalSettings(this._sharedPreferences);

  String get currentCountry {
    return _sharedPreferences
        .getString(_kCountryKey) ?? _kDefaultCountry;
  }

  set currentCountry(String country) {
    _sharedPreferences.setString(_kCountryKey, country);
  }
}
