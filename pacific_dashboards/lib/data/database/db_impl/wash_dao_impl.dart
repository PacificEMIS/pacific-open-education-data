import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_wash_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';

class HiveWashDao extends WashDao {
  static const _kKey = 'HiveWashDao';

  static Future<T> _withBox<T>(
    Future<T> Function(Box<HiveWashChunk> box) action,
  ) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<WashChunk> get(Emis emis) async {
    final storedChunk = await _withBox((box) async => box.get(emis.id));
    return storedChunk?.toWashChunk();
  }

  @override
  Future<void> save(WashChunk chunk, Emis emis) async {
    final hiveChunk = HiveWashChunk.from(chunk);
    await _withBox((box) async => box.put(emis.id, hiveChunk));
  }
}
