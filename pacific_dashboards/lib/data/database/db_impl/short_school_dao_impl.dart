import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/short_school/hive_short_school.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';

class HiveShortSchoolDao extends ShortSchoolDao {
  static const _kKey = 'HiveShortSchoolDao';

  static Future<T> _withBox<T>(Future<T> action(Box<List> box)) async {
    final Box<List> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<List<ShortSchool>> get(Emis emis) async {
    final storedSchools = await _withBox((box) async => box.get(emis.id));
    if (storedSchools == null) {
      return null;
    }
    final List<ShortSchool> storedItems = [];
    for (var value in storedSchools) {
      final hiveSchool = value as HiveShortSchool;
      storedItems.add(hiveSchool.toShortSchool());
    }
    return storedItems;
  }

  @override
  Future<void> save(
    List<ShortSchool> enroll,
    Emis emis,
  ) async {
    final hiveSchool = enroll.map((it) => HiveShortSchool.from(it)).toList();
    await _withBox((box) async => box.put(emis.id, hiveSchool));
  }
}
