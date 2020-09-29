import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/financial_lookup/hive_financial_lookups.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';

class HiveFinancialLookupsDao extends FinancialLookupsDao {
  static const _kKey = 'financial_lookups';

  static Future<T> _withBox<T>(
      Future<T> action(Box<HiveFinancialLookups> box)) async {
    final Box<HiveFinancialLookups> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<Pair<bool, FinancialLookups>> get(Emis emis) async {
    final storedFinancialLookups =
        await _withBox((box) async => box.get(emis.id));

    if (storedFinancialLookups == null) {
      return Pair(false, null);
    }

    return Pair(storedFinancialLookups.isExpired(),
        storedFinancialLookups.toFinancialLookups());
  }

  @override
  Future<void> save(FinancialLookups lookups, Emis emis) async {
    final hiveFinancialLookups = HiveFinancialLookups.from(lookups)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    await _withBox((box) async => box.put(emis.id, hiveFinancialLookups));
  }
}
