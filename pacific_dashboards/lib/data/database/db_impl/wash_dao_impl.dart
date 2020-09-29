import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_accreditation_chunk.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_wash_chunk.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';

class HiveWashDao extends WashDao {
  static const _kKey = 'wash';

  static Future<T> _withBox<T>(Future<T> action(Box<HiveWashChunk> box)) async {
    final Box<HiveWashChunk> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<WashChunk> get(Emis emis) async {
    final storedChunk = await _withBox((box) async => box.get(emis.id));
    return storedChunk?.toWashChunk() ?? null;
  }

  @override
  Future<void> save(WashChunk chunk, Emis emis) async {
    final hiveChunk = HiveWashChunk.from(chunk)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    await _withBox((box) async => box.put(emis.id, hiveChunk));
  }
}
