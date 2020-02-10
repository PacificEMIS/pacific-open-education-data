import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';

class HiveStringsDao extends StringsDao {
  Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox('kvs');
  }

  @override
  Future<String> getByKey(String key, {String defaultValue}) async {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> save(String key, String string) => _box.put(key, string);
}
