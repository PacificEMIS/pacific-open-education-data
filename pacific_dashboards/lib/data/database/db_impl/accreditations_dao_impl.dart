import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';

class HiveAccreditationsDao extends AccreditationsDao {
  static const _kKey = 'accreditations';

  static Future<T> _withBox<T>(
      Future<T> action(Box<HiveAccreditationChunk> box)) async {
    final Box<HiveAccreditationChunk> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<AccreditationChunk> get(Emis emis) async {
    final storedChunk = await _withBox((box) async => box.get(emis.id));
    return storedChunk?.toAccreditationChunk() ?? null;
  }

  @override
  Future<void> save(AccreditationChunk chunk, Emis emis) async {
    final hiveChunk = HiveAccreditationChunk.from(chunk)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    await _withBox((box) async => box.put(emis.id, hiveChunk));
  }
}
