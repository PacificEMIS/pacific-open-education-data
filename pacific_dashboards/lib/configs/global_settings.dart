import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/models/emis.dart';

class GlobalSettings {

  const GlobalSettings(this._stringsDao);
  
  static const kDefaultEmis = Emis.fedemis;
  static const _kApiUser = String.fromEnvironment('envApiUser');
  static const _kApiPassword = String.fromEnvironment('envApiPassword');
  static const _kEmisKey = 'emis';
  static const _kVersionSuffix = '_version';

  final StringsDao _stringsDao;

  Future<Emis> get currentEmis async {
    return emisFromString(await _stringsDao.getByKey(_kEmisKey)) ??
        kDefaultEmis;
  }

  Future<void> setCurrentEmis(Emis emis) =>
      _stringsDao.save(_kEmisKey, emis.toString());

  Future<String> getEtag(String path) =>
      _stringsDao.getByKey(path + _kVersionSuffix);

  Future<void> setEtag(String path, String etag) =>
      _stringsDao.save(path + _kVersionSuffix, etag);

  String getApiUserName() => _kApiUser;

  String getApiPassword() => _kApiPassword;
}
