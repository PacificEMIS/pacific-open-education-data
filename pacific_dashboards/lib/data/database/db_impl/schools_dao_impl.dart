import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school/hive_school.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school/school.dart';

class HiveSchoolsDao extends SchoolsDao {
  static const _kKey = 'schools';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<List<School>> get(Emis emis) async {
    final storedSchools = await _withBox((box) async => box.get(emis.id));
    if (storedSchools == null) {
      return null;
    }
    final storedItems = <School>[];
    for (final value in storedSchools) {
      final hiveSchool = value as HiveSchool;
      storedItems.add(hiveSchool.toSchool());
    }
    return storedItems;
  }

  @override
  Future<void> save(List<School> schools, Emis emis) async {
    final hiveSchools = schools
        .map((it) => HiveSchool.from(it)
          ..timestamp = DateTime.now().millisecondsSinceEpoch)
        .toList();

    await _withBox((box) async => box.put(emis.id, hiveSchools));
  }
}
