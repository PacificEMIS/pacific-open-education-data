import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_district_accreditation.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_standard_accreditation.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';

part 'hive_accreditation_chunk.g.dart';

@HiveType(typeId: 6)
class HiveAccreditationChunk extends HiveObject with Expirable {
  @HiveField(0)
  List<HiveDistrictAccreditation> byDistrict;

  @HiveField(1)
  List<HiveStandardAccreditation> byStandard;

  @override
  @HiveField(2)
  int timestamp;

  AccreditationChunk toAccreditationChunk() => AccreditationChunk(
        byDistrict: byDistrict.map((it) => it.toAccreditation()).toList(),
        byStandard: byStandard.map((it) => it.toAccreditation()).toList(),
      );

  static HiveAccreditationChunk from(AccreditationChunk accreditationChunk) =>
      HiveAccreditationChunk()
        ..byDistrict = accreditationChunk.byDistrict
            .map((it) => HiveDistrictAccreditation.from(it))
            .toList()
        ..byStandard = accreditationChunk.byStandard
            .map((it) => HiveStandardAccreditation.from(it))
            .toList();
}
