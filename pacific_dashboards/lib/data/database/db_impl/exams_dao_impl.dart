import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/exam/hive_exam.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/pair.dart';

class HiveExamsDao extends ExamsDao {
  static const _kKey = 'exams';

  static Future<T> _withBox<T>(Future<T> action(Box<List> box)) async {
    final Box<List> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<Pair<bool, List<Exam>>> get(Emis emis) async {
    final storedExams = await _withBox((box) async => box.get(emis.id));
    if (storedExams == null) {
      return Pair(false, null);
    }
    var expired = false;
    List<Exam> storedItems = [];
    for (var value in storedExams) {
      final hiveExam = value as HiveExam;
      expired |= hiveExam.isExpired();
      storedItems.add(hiveExam.toExam());
    }
    return Pair(expired, storedItems);
  }

  @override
  Future<void> save(List<Exam> exams, Emis emis) async {
    final hiveExams = exams
        .map((it) => HiveExam.from(it)
          ..timestamp = DateTime.now().millisecondsSinceEpoch)
        .toList();

    await _withBox((box) async => box.put(emis.id, hiveExams));
  }
}
