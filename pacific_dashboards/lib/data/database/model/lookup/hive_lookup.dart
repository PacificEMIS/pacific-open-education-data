import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';

part 'hive_lookup.g.dart';

@HiveType(typeId: 1)
class HiveLookup {
  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  @HiveField(2)
  String l;

  Lookup toLookup() => Lookup((b) => b
    ..name = name
    ..code = code
    ..l = l);

  static HiveLookup from(Lookup lookup) {
    return HiveLookup()
      ..code = lookup.code
      ..name = lookup.name
      ..l = lookup.l;
  }
}
