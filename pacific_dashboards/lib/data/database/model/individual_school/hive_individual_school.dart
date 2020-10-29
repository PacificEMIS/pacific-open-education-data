import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/data/database/model/individual_school/hive_individual_accreditation.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';

part 'hive_individual_school.g.dart';

@HiveType(typeId: 17)
class HiveIndividualSchool extends HiveObject with Expirable {
  @HiveField(0)
  List<HiveIndividualAccreditation> accreditationList;

  IndividualSchool toIndividualSchool() => IndividualSchool(
        accreditationList: accreditationList
            .map((e) => e.toIndividualAccreditation())
            .toList(),
      );

  static HiveIndividualSchool from(IndividualSchool school) =>
      HiveIndividualSchool()
        ..accreditationList = school.accreditationList
            .map((e) => HiveIndividualAccreditation.from(e))
            .toList();
}
