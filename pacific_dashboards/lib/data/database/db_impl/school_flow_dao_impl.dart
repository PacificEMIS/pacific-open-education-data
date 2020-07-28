import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school_enroll/hive_school_enroll.dart';
import 'package:pacific_dashboards/data/database/model/school_flow/hive_school_flow.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';

class HiveSchoolFlowDao extends SchoolFlowDao {
  static const _kKey = 'HiveSchoolFlowDao';

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
  Future<List<SchoolFlow>> get(String schoolId, Emis emis) async {
    final storedFlows =
        await _withBox((box) async => box.get(_generateKey(schoolId, emis)));
    if (storedFlows == null) {
      return null;
    }
    final List<SchoolFlow> storedItems = [];
    for (var value in storedFlows) {
      final hiveSchoolFlow = value as HiveSchoolFlow;
      storedItems.add(hiveSchoolFlow.toSchoolFlow());
    }
    return storedItems;
  }

  @override
  Future<void> save(
    String schoolId,
    List<SchoolFlow> flows,
    Emis emis,
  ) async {
    final hiveSchoolFlows = flows.map((it) => HiveSchoolFlow.from(it)).toList();

    await _withBox(
        (box) async => box.put(_generateKey(schoolId, emis), hiveSchoolFlows));
  }
}
