import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/individual_accreditation/individual_accreditation.dart';

part 'hive_individual_accreditation.g.dart';

@HiveType(typeId: 16)
class HiveIndividualAccreditation extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  String result;

  @HiveField(2)
  double se_1;

  @HiveField(3)
  double se_1_1;

  @HiveField(4)
  double se_1_2;

  @HiveField(5)
  double se_1_3;

  @HiveField(6)
  double se_1_4;

  @HiveField(7)
  double se_2;

  @HiveField(8)
  double se_2_1;

  @HiveField(9)
  double se_2_2;

  @HiveField(10)
  double se_2_3;

  @HiveField(11)
  double se_2_4;

  @HiveField(12)
  double se_3;

  @HiveField(13)
  double se_3_1;

  @HiveField(14)
  double se_3_2;

  @HiveField(15)
  double se_3_3;

  @HiveField(16)
  double se_3_4;

  @HiveField(17)
  double se_4;

  @HiveField(18)
  double se_4_1;

  @HiveField(19)
  double se_4_2;

  @HiveField(20)
  double se_4_3;

  @HiveField(21)
  double se_4_4;

  @HiveField(22)
  double se_5;

  @HiveField(23)
  double se_5_1;

  @HiveField(24)
  double se_5_2;

  @HiveField(25)
  double se_5_3;

  @HiveField(26)
  double se_5_4;

  @HiveField(27)
  double se_6;

  @HiveField(28)
  double se_6_1;

  @HiveField(29)
  double se_6_2;

  @HiveField(30)
  double se_6_3;

  @HiveField(31)
  double se_6_4;

  @HiveField(32)
  double co_1;

  @HiveField(33)
  double co_2;

  @HiveField(34)
  String inspectedBy;

  @HiveField(35)
  int inspectionYear;

  IndividualAccreditation toIndividualAccreditation() =>
      IndividualAccreditation(
        dateTime: dateTime,
        inspectionYear: inspectionYear,
        result: result,
        se_1: se_1,
        se_1_1: se_1_1,
        se_1_2: se_1_2,
        se_1_3: se_1_3,
        se_1_4: se_1_4,
        se_2: se_2,
        se_2_1: se_2_1,
        se_2_2: se_2_2,
        se_2_3: se_2_3,
        se_2_4: se_2_4,
        se_3: se_3,
        se_3_1: se_3_1,
        se_3_2: se_3_2,
        se_3_3: se_3_3,
        se_3_4: se_3_4,
        se_4: se_4,
        se_4_1: se_4_1,
        se_4_2: se_4_2,
        se_4_3: se_4_3,
        se_4_4: se_4_4,
        se_5: se_5,
        se_5_1: se_5_1,
        se_5_2: se_5_2,
        se_5_3: se_5_3,
        se_5_4: se_5_4,
        se_6: se_6,
        se_6_1: se_6_1,
        se_6_2: se_6_2,
        se_6_3: se_6_3,
        se_6_4: se_6_4,
        co_1: co_1,
        co_2: co_2,
        inspectedBy: inspectedBy,
      );

  static HiveIndividualAccreditation from(
    IndividualAccreditation accreditation,
  ) =>
      HiveIndividualAccreditation()
        ..dateTime = accreditation.dateTime
        ..inspectionYear = accreditation.inspectionYear
        ..result = accreditation.result
        ..se_1 = accreditation.se_1
        ..se_1_1 = accreditation.se_1_1
        ..se_1_2 = accreditation.se_1_2
        ..se_1_3 = accreditation.se_1_3
        ..se_1_4 = accreditation.se_1_4
        ..se_2 = accreditation.se_2
        ..se_2_1 = accreditation.se_2_1
        ..se_2_2 = accreditation.se_2_2
        ..se_2_3 = accreditation.se_2_3
        ..se_2_4 = accreditation.se_2_4
        ..se_3 = accreditation.se_3
        ..se_3_1 = accreditation.se_3_1
        ..se_3_2 = accreditation.se_3_2
        ..se_3_3 = accreditation.se_3_3
        ..se_3_4 = accreditation.se_3_4
        ..se_4 = accreditation.se_4
        ..se_4_1 = accreditation.se_4_1
        ..se_4_2 = accreditation.se_4_2
        ..se_4_3 = accreditation.se_4_3
        ..se_4_4 = accreditation.se_4_4
        ..se_5 = accreditation.se_5
        ..se_5_1 = accreditation.se_5_1
        ..se_5_2 = accreditation.se_5_2
        ..se_5_3 = accreditation.se_5_3
        ..se_5_4 = accreditation.se_5_4
        ..se_6 = accreditation.se_6
        ..se_6_1 = accreditation.se_6_1
        ..se_6_2 = accreditation.se_6_2
        ..se_6_3 = accreditation.se_6_3
        ..se_6_4 = accreditation.se_6_4
        ..co_1 = accreditation.co_1
        ..co_2 = accreditation.co_2
        ..inspectedBy = accreditation.inspectedBy;
}
