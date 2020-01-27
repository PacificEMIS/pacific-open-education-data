import 'package:hive/hive.dart';

abstract class KeyStringStorage {
  Future<void> set(String key, String value);
  String get(String key, { String defaultValue });
}

class HiveKeyStringStorage extends KeyStringStorage {

  Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox('kvs');
  }

  @override
  String get(String key, { String defaultValue }) {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> set(String key, String value) {
    return _box.put(key, value);
  }

}