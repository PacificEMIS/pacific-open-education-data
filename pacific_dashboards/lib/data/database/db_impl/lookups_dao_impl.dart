import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookups.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

class HiveLookupsDao extends LookupsDao {

  static const _kLookupsKey = 'lookups';

  static Future<T> _withBox<T>(Future<T> action(Box<HiveLookups> box)) async {
    final Box<HiveLookups> box = await Hive.openBox(_kLookupsKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<Lookups> get(Emis emis) async {
    final storedLookups = await _withBox((box) async => box.get(emis.id));
    return storedLookups?.toLookups() ?? null;
  }

  @override
  Future<void> save(Lookups lookups, Emis emis) async {
    final hiveLookups = HiveLookups.from(lookups)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    await _withBox((box) async => box.put(emis.id, hiveLookups));
  }

}

extension _HiveId on Emis {
  int get id {
    switch (this) {
      case Emis.miemis:
        return 0;
      case Emis.fedemis:
        return 1;
      case Emis.kemis:
        return 2;
    }
    throw FallThroughError();
  }
}