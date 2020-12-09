import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_district_accreditation.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_national_accreditation.dart';
import 'package:pacific_dashboards/data/database/model/accreditation/hive_standard_accreditation.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';

part 'hive_accreditation_chunk.g.dart';

@HiveType(typeId: 6)
class HiveAccreditationChunk extends HiveObject with Expirable {
  HiveAccreditationChunk();

  HiveAccreditationChunk.from(AccreditationChunk accreditationChunk)
      : byDistrict = accreditationChunk.byDistrict
            .map((it) => HiveDistrictAccreditation.from(it))
            .toList(),
        byStandard = accreditationChunk.byStandard
            .map((it) => HiveStandardAccreditation.from(it))
            .toList(),
        byNational = accreditationChunk.byNational
            .map((it) => HiveNationalAccreditation.from(it))
            .toList();

  @HiveField(0)
  List<HiveDistrictAccreditation> byDistrict;

  @HiveField(1)
  List<HiveStandardAccreditation> byStandard;

  @HiveField(2)
  List<HiveNationalAccreditation> byNational;

  @override
  @HiveField(3)
  int timestamp;

  AccreditationChunk toAccreditationChunk() => AccreditationChunk(
        byDistrict: byDistrict.map((it) => it.toAccreditation()).toList(),
        byStandard: byStandard.map((it) => it.toAccreditation()).toList(),
        byNational: byNational.map((it) => it.toAccreditation()).toList(),
      );
}
