import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/db_impl/lookups_dao_impl.dart';
import 'package:pacific_dashboards/data/database/db_impl/strings_dao_impl.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookup.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookups.dart';

class HiveDatabase extends Database {
  LookupsDao _lookupsDao;
  StringsDao _stringsDao;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(HiveLookupsAdapter())
      ..registerAdapter(HiveLookupAdapter());

    _lookupsDao = HiveLookupsDao();

    final stringDao = HiveStringsDao();
    await stringDao.init();
    _stringsDao = stringDao;
  }

  @override
  LookupsDao get lookups => _lookupsDao;

  @override
  StringsDao get strings => _stringsDao;
}
