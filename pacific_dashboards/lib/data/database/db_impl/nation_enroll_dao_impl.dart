import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school_enroll/hive_school_enroll.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

class HiveNationEnrollDao extends NationEnrollDao {
  static const _kKey = 'HiveNationEnrollDao';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox<List>(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<List<SchoolEnroll>> get(Emis emis) async {
    final storedEnrolls = await _withBox((box) async => box.get(emis.id));
    if (storedEnrolls == null) {
      return null;
    }
    final storedItems = <SchoolEnroll>[];
    for (final value in storedEnrolls) {
      final hiveSchoolEnroll = value as HiveSchoolEnroll;
      storedItems.add(hiveSchoolEnroll.toSchoolEnroll());
    }
    return storedItems;
  }

  @override
  Future<void> save(
    List<SchoolEnroll> enroll,
    Emis emis,
  ) async {
    final hiveSchoolEnrolls =
        enroll.map((it) => HiveSchoolEnroll.from(it)).toList();
    await _withBox((box) async => box.put(emis.id, hiveSchoolEnrolls));
  }
}
