import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school_enroll/hive_school_enroll.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

class HiveSchoolEnrollDao extends SchoolEnrollDao {
  static const _kKey = 'SchoolEnrollDao';

  static Future<T> _withBox<T>(Future<T> action(Box<List> box)) async {
    final Box<List> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  static String _generateKey(String schoolId, Emis emis) {
    return '$schoolId-${emis.id}';
  }

  @override
  Future<List<SchoolEnroll>> get(String schoolId, Emis emis) async {
    final storedEnrolls =
        await _withBox((box) async => box.get(_generateKey(schoolId, emis)));
    if (storedEnrolls == null) {
      return null;
    }
    final List<SchoolEnroll> storedItems = [];
    for (var value in storedEnrolls) {
      final hiveSchoolEnroll = value as HiveSchoolEnroll;
      storedItems.add(hiveSchoolEnroll.toSchoolEnroll());
    }
    return storedItems;
  }

  @override
  Future<void> save(
      String schoolId, List<SchoolEnroll> enroll, Emis emis) async {
    final hiveSchoolEnrolls =
        enroll.map((it) => HiveSchoolEnroll.from(it)).toList();

    await _withBox((box) async =>
        box.put(_generateKey(schoolId, emis), hiveSchoolEnrolls));
  }
}
