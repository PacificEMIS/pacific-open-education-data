import 'package:built_collection/built_collection.dart';
import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school/hive_school.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school/school.dart';

class HiveSchoolsDao extends SchoolsDao {
  static const _kKey = 'schools';

  static Future<T> _withBox<T>(Future<T> action(Box<List> box)) async {
    final Box<List> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<BuiltList<School>> get(Emis emis) async {
    final storedSchools =
        await _withBox((box) async => box.get(emis.id));
    if (storedSchools == null) {
      return null;
    }
    List<School> storedItems = [];
    for (var value in storedSchools) {
      final hiveSchool = value as HiveSchool;
      storedItems.add(hiveSchool.toSchool());
    }
    return storedItems.build();
  }

  @override
  Future<void> save(BuiltList<School> schools, Emis emis) async {
    final hiveSchools = schools
        .map((it) => HiveSchool.from(it)
          ..timestamp = DateTime.now().millisecondsSinceEpoch)
        .toList();

    await _withBox((box) async => box.put(emis.id, hiveSchools));
  }
}
