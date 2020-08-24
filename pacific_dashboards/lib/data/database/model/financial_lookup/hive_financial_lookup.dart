import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookup.dart';
part 'hive_financial_lookup.g.dart';

@HiveType(typeId: 16)
class HiveFinancialLookup {
  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  FinancialLookup toFinancialLookup() => FinancialLookup(
        name: name,
        code: code,
      );

  static HiveFinancialLookup from(FinancialLookup lookup) {
    return HiveFinancialLookup()
      ..code = lookup.code
      ..name = lookup.name;
  }
}
