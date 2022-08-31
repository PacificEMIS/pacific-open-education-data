import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/models/emis.dart';

class GlobalSettings {
  static const kDefaultEmis = Emis.fedemis;
  static const _kApiUser = const String.fromEnvironment('envApiUser');
  static const _kApiPassword = const String.fromEnvironment('envApiPassword');
  static const _kEmisKey = "emis";
  static const _kVersionSuffix = "_version";
  static const _kAppVersion = "1.1.6";

  final StringsDao _stringsDao;

  GlobalSettings(this._stringsDao);

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

  String getAppVersion() => _kAppVersion;
}
