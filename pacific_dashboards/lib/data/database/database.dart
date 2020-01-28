import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

abstract class Database {
  LookupsDao get lookups;
  StringsDao get strings;
}

abstract class LookupsDao {
  Future<void> save(Lookups lookups, Emis emis);
  Future<Lookups> get(Emis emis);
}

abstract class StringsDao {
  Future<void> save(String key, String string);
  Future<String> getByKey(String key, {String defaultValue});
}