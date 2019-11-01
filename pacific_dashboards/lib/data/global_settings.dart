import 'package:pacific_dashboards/models/emis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const kDefaultEmis = Emis.fedemis;
  static const _kEmisKey = "emis";
  static const _kVersionSuffix = "_version";

  final SharedPreferences _sharedPreferences;

  GlobalSettings(this._sharedPreferences);

  Emis get currentEmis {
    return emisFromString(_sharedPreferences.getString(_kEmisKey)) ?? kDefaultEmis;
  }

  Future<bool> setCurrentEmis(Emis emis) {
    return _sharedPreferences.setString(_kEmisKey, emis.toString());
  }

  String getEtag(String path) {
    return _sharedPreferences.getString(path + _kVersionSuffix);
  }

  Future<bool> setEtag(String path, String etag) {
    return _sharedPreferences.setString(path + _kVersionSuffix, etag);
  }
}
