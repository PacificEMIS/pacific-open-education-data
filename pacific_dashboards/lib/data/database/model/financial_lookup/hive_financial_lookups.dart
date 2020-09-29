import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/financial_lookups/financial_lookups.dart';
import 'hive_financial_lookup.dart';

part 'hive_financial_lookups.g.dart';

@HiveType(typeId: 15)
class HiveFinancialLookups extends HiveObject with Expirable {
  @HiveField(0)
  List<HiveFinancialLookup> costCentres;

  @HiveField(1)
  List<HiveFinancialLookup> fundingSources;

  @HiveField(2)
  List<HiveFinancialLookup> fundingSourceGroups;

  FinancialLookups toFinancialLookups() => FinancialLookups();

  static HiveFinancialLookups from(FinancialLookups lookups) =>
      HiveFinancialLookups()
        ..costCentres = lookups.costCentres
            .map((it) => HiveFinancialLookup.from(it))
            .toList()
        ..fundingSources = lookups.fundingSources
            .map((it) => HiveFinancialLookup.from(it))
            .toList()
        ..fundingSourceGroups = lookups.fundingSourceGroups
            .map((it) => HiveFinancialLookup.from(it))
            .toList();
}
