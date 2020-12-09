import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/special_education/hive_special_education.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';

class HiveSpecialEducationDao extends SpecialEducationDao {
  static const _kKey = 'HiveSpecialEducationDao';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox<List>(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<List<SpecialEducation>> get(Emis emis) async {
    final storedSpecialEducation =
        await _withBox((box) async => box.get(emis.id));
    if (storedSpecialEducation == null) {
      return null;
    }
    final storedItems = <SpecialEducation>[];
    for (final value in storedSpecialEducation) {
      final hiveSpecialEducation = value as HiveSpecialEducation;
      storedItems.add(hiveSpecialEducation.toSpecialEducation());
    }
    return storedItems;
  }

  @override
  Future<void> save(List<SpecialEducation> specialEducation, Emis emis) async {
    final hiveSpecialEducation =
        specialEducation.map((it) => HiveSpecialEducation.from(it)).toList();

    await _withBox((box) async => box.put(emis.id, hiveSpecialEducation));
  }
}
