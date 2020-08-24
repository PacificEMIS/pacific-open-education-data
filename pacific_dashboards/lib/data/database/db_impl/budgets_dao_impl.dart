import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/database.dart';
import 'package:pacific_dashboards/data/database/model/budget/hive_budget.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/emis.dart';

class HiveBudgetsDao extends BudgetsDao {
  static const _kKey = 'budgets';

  static Future<T> _withBox<T>(Future<T> action(Box<List> box)) async {
    final Box<List> box = await Hive.openBox(_kKey);
    final result = await action(box);
    await box.close();
    return result;
  }

  @override
  Future<List<Budget>> get(Emis emis) async {
    final storedBudgets = await _withBox((box) async => box.get(emis.id));
    if (storedBudgets == null) {
      return null;
    }
    List<Budget> storedItems = [];
    for (var value in storedBudgets) {
      final hiveBudget = value as HiveBudget;
      storedItems.add(hiveBudget.toBudget());
    }
    return storedItems;
  }

  @override
  Future<void> save(List<Budget> budgets, Emis emis) async {
    final hiveBudgets = budgets
        .map((it) => HiveBudget.from(it)
          ..timestamp = DateTime.now().millisecondsSinceEpoch)
        .toList();

    await _withBox((box) async => box.put(emis.id, hiveBudgets));
  }
}
