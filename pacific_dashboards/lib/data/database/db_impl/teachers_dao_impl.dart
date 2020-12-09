import 'package:arch/arch.dart';
import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/teacher/hive_teacher.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';

class HiveTeachersDao extends TeachersDao {
  static const _kKey = 'teachers';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<Pair<bool, List<Teacher>>> get(Emis emis) async {
    final storedTeachers = await _withBox((box) async => box.get(emis.id));
    if (storedTeachers == null) {
      return const Pair(false, null);
    }
    var expired = false;
    final storedItems = <Teacher>[];
    for (final value in storedTeachers) {
      final hiveTeacher = value as HiveTeacher;
      expired |= hiveTeacher.isExpired();
      storedItems.add(hiveTeacher.toTeacher());
    }
    return Pair(expired, storedItems);
  }

  @override
  Future<void> save(List<Teacher> teachers, Emis emis) async {
    final hiveTeachers = teachers
        .map((it) => HiveTeacher.from(it)
          ..timestamp = DateTime.now().millisecondsSinceEpoch)
        .toList();

    await _withBox((box) async => box.put(emis.id, hiveTeachers));
  }
}
