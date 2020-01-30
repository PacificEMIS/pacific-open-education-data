import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';

part 'hive_standard_accreditation.g.dart';

@HiveType(typeId: 7)
class HiveStandardAccreditation extends HiveObject {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String districtCode;

  @HiveField(2)
  String authorityCode;

  @HiveField(3)
  String authorityGovtCode;

  @HiveField(4)
  String schoolTypeCode;

  @HiveField(5)
  String standard;

  @HiveField(6)
  String result;

  @HiveField(7)
  int num;

  @HiveField(8)
  int numInYear;

  StandardAccreditation toAccreditation() => StandardAccreditation(
        (b) => b
          ..surveyYear = surveyYear
          ..districtCode = districtCode
          ..authorityCode = authorityCode
          ..authorityGovtCode = authorityGovtCode
          ..schoolTypeCode = schoolTypeCode
          ..standard = standard
          ..result = result
          ..num = num
          ..numInYear = numInYear,
      );

  static HiveStandardAccreditation from(StandardAccreditation accreditation) =>
      HiveStandardAccreditation()
        ..surveyYear = accreditation.surveyYear
        ..districtCode = accreditation.districtCode
        ..authorityCode = accreditation.authorityCode
        ..authorityGovtCode = accreditation.authorityGovtCode
        ..schoolTypeCode = accreditation.schoolTypeCode
        ..standard = accreditation.standard
        ..result = accreditation.result
        ..num = accreditation.num
        ..numInYear = accreditation.numInYear;
}
