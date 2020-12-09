import 'package:arch/arch.dart';
import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookups.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

class HiveLookupsDao extends LookupsDao {
  static const _kKey = 'lookups';

  static Future<T> _withBox<T>(
    Future<T> Function(Box<HiveLookups> box) action,
  ) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<Pair<bool, Lookups>> get(Emis emis) async {
    final storedLookups = await _withBox((box) async => box.get(emis.id));

    if (storedLookups == null) {
      return const Pair(false, null);
    }

    return Pair(storedLookups.isExpired(), storedLookups.toLookups());
  }

  @override
  Future<void> save(Lookups lookups, Emis emis) async {
    final hiveLookups = HiveLookups.from(lookups)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    await _withBox((box) async => box.put(emis.id, hiveLookups));
  }
}
