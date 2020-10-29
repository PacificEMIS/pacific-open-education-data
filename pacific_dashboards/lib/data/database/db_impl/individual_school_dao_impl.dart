import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/individual_school/hive_individual_school.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';

class HiveIndividualSchoolDao extends IndividualSchoolDao {
  static const _kKey = 'HiveIndividualSchoolDao';

  static Future<T> _withBox<T>(
    Future<T> action(Box<HiveIndividualSchool> box),
  ) async {
    final Box<HiveIndividualSchool> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  static String _generateKey(String schoolId, Emis emis) {
    return '$schoolId-${emis.id}';
  }

  @override
  Future<IndividualSchool> get(String schoolId, Emis emis) async {
    final storedSchool =
        await _withBox((box) async => box.get(_generateKey(schoolId, emis)));
    return storedSchool?.toIndividualSchool();
  }

  @override
  Future<void> save(
    String schoolId,
    IndividualSchool school,
    Emis emis,
  ) async {
    final hiveSchool = HiveIndividualSchool.from(school);

    await _withBox(
      (box) async => box.put(_generateKey(schoolId, emis), hiveSchool),
    );
  }
}
