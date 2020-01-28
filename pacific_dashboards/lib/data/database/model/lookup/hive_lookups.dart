import 'package:built_collection/built_collection.dart';
import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookup.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'hive_lookups.g.dart';

@HiveType(typeId: 0)
class HiveLookups extends HiveObject with Expirable {
  @HiveField(0)
  List<HiveLookup> authorityGovt;

  @HiveField(1)
  List<HiveLookup> schoolTypes;

  @HiveField(2)
  List<HiveLookup> districts;

  @HiveField(3)
  List<HiveLookup> authorities;

  @HiveField(4)
  List<HiveLookup> levels;

  @HiveField(5)
  List<HiveLookup> accreditationTerms;

  @override
  @HiveField(6)
  int timestamp;

  Lookups toLookups() => Lookups(
        (b) => b
          ..authorityGovt =
              ListBuilder(authorityGovt.map((it) => it.toLookup()))
          ..schoolTypes = ListBuilder(schoolTypes.map((it) => it.toLookup()))
          ..districts = ListBuilder(districts.map((it) => it.toLookup()))
          ..authorities = ListBuilder(authorities.map((it) => it.toLookup()))
          ..levels = ListBuilder(levels.map((it) => it.toLookup()))
          ..accreditationTerms =
              ListBuilder(accreditationTerms.map((it) => it.toLookup())),
      );

  static HiveLookups from(Lookups lookups) => HiveLookups()
    ..authorityGovt =
        lookups.authorityGovt.map((it) => HiveLookup.from(it)).toList()
    ..schoolTypes =
        lookups.schoolTypes.map((it) => HiveLookup.from(it)).toList()
    ..districts = lookups.districts.map((it) => HiveLookup.from(it)).toList()
    ..authorities =
        lookups.authorities.map((it) => HiveLookup.from(it)).toList()
    ..levels = lookups.levels.map((it) => HiveLookup.from(it)).toList()
    ..accreditationTerms =
        lookups.accreditationTerms.map((it) => HiveLookup.from(it)).toList();
}
