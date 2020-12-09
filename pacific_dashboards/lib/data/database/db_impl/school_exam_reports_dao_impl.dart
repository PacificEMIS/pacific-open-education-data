import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/school_exam_report/hive_school_exam_report.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';

class HiveSchoolExamsReportDao extends SchoolExamReportsDao {
  static const _kKey = 'HiveSchoolExamsReportDao';

  static Future<T> _withBox<T>(Future<T> Function(Box<List> box) action) async {
    final box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  static String _generateKey(String schoolId, Emis emis) {
    return '$schoolId-${emis.id}';
  }

  @override
  Future<List<SchoolExamReport>> get(String schoolId, Emis emis) async {
    final storedReports =
        await _withBox((box) async => box.get(_generateKey(schoolId, emis)));
    if (storedReports == null) {
      return null;
    }
    final storedItems = <SchoolExamReport>[];
    for (final value in storedReports) {
      final hiveSchoolExamReport = value as HiveSchoolExamReport;
      storedItems.add(hiveSchoolExamReport.toSchoolExamReport());
    }
    return storedItems;
  }

  @override
  Future<void> save(
    String schoolId,
    List<SchoolExamReport> reports,
    Emis emis,
  ) async {
    final hiveSchoolExamReports =
        reports.map((it) => HiveSchoolExamReport.from(it)).toList();
    await _withBox((box) async => box.put(
          _generateKey(schoolId, emis),
          hiveSchoolExamReports,
        ));
  }
}
