import 'package:pacific_dashboards/data/local/storages/key_string_storage.dart';
import 'package:pacific_dashboards/models/emis.dart';

class GlobalSettings {
  static const kDefaultEmis = Emis.fedemis;
  static const _kEmisKey = "emis";
  static const _kVersionSuffix = "_version";

  final KeyStringStorage _storage;

  GlobalSettings(this._storage);

  Emis get currentEmis {
    return emisFromString(_storage.get(_kEmisKey)) ?? kDefaultEmis;
  }

  Future<void> setCurrentEmis(Emis emis) {
    return _storage.set(_kEmisKey, emis.toString());
  }

  String getEtag(String path) {
    return _storage.get(path + _kVersionSuffix);
  }

  Future<void> setEtag(String path, String etag) {
    return _storage.set(path + _kVersionSuffix, etag);
  }
}