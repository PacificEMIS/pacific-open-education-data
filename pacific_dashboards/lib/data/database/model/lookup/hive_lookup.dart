import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';

part 'hive_lookup.g.dart';

@HiveType(typeId: 1)
class HiveLookup {
  HiveLookup();

  HiveLookup.from(Lookup lookup)
      : code = lookup.code,
        name = lookup.name;

  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  Lookup toLookup() => Lookup(
        name: name,
        code: code,
      );
}
