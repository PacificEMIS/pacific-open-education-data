import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school_enroll/hive_school_enroll.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

class HiveDistrictEnrollDao extends DistrictEnrollDao {
  static const _kKey = 'HiveDistrictEnrollDao';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  static String _generateKey(String districtCode, Emis emis) {
    return '$districtCode-${emis.id}';
  }

  @override
  Future<List<SchoolEnroll>> get(String districtCode, Emis emis) async {
    final storedEnrolls = await _withBox(
      (box) async => box.get(_generateKey(districtCode, emis)),
    );
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
    String districtCode,
    List<SchoolEnroll> enroll,
    Emis emis,
  ) async {
    final hiveSchoolEnrolls =
        enroll.map((it) => HiveSchoolEnroll.from(it)).toList();
    await _withBox((box) async =>
        box.put(_generateKey(districtCode, emis), hiveSchoolEnrolls));
  }
}
