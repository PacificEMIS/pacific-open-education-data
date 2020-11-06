import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_class_level_lookup.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_lookup.dart';
import 'package:pacific_dashboards/data/database/model/lookup/hive_school_type_lookup.dart';
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
  List<HiveClassLevelLookup> levels;

  @HiveField(5)
  List<HiveLookup> accreditationTerms;

  @HiveField(6)
  List<HiveLookup> educationLevels;

  @override
  @HiveField(7)
  int timestamp;

  @HiveField(8)
  List<HiveLookup> schoolCodes;

  @HiveField(9)
  List<HiveSchoolTypeLookup> schoolTypeLevels;

  Lookups toLookups() =>
      Lookups(
        authorityGovt: authorityGovt.map((it) => it.toLookup()).toList(),
        schoolTypes: schoolTypes.map((it) => it.toLookup()).toList(),
        districts: districts.map((it) => it.toLookup()).toList(),
        authorities: authorities.map((it) => it.toLookup()).toList(),
        levels: levels.map((it) => it.toLookup()).toList(),
        accreditationTerms:
        accreditationTerms.map((it) => it.toLookup()).toList(),
        educationLevels: educationLevels.map((it) => it.toLookup()).toList(),
        schoolCodes: schoolCodes.map((it) => it.toLookup()).toList(),
        schoolTypeLevels: schoolTypeLevels.map((it) => it.toLookup()).toList(),
      );

  static HiveLookups from(Lookups lookups) =>
      HiveLookups()
        ..authorityGovt =
        lookups.authorityGovt.map((it) => HiveLookup.from(it)).toList()
        ..schoolTypes =
        lookups.schoolTypes.map((it) => HiveLookup.from(it)).toList()
        ..districts = lookups.districts.map((it) => HiveLookup.from(it))
            .toList()
        ..authorities =
        lookups.authorities.map((it) => HiveLookup.from(it)).toList()
        ..levels =
        lookups.levels.map((it) => HiveClassLevelLookup.from(it)).toList()
        ..accreditationTerms =
        lookups.accreditationTerms.map((it) => HiveLookup.from(it)).toList()
        ..educationLevels =
        lookups.educationLevels.map((it) => HiveLookup.from(it)).toList()
        ..schoolCodes =
        lookups.schoolCodes.map((it) => HiveLookup.from(it)).toList()
        ..schoolTypeLevels =
        lookups.schoolTypeLevels.map((it) => HiveSchoolTypeLookup.from(it))
            .toList();
}
