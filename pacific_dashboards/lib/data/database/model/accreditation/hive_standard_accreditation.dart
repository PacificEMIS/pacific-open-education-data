import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';

part 'hive_standard_accreditation.g.dart';

@HiveType(typeId: 7)
class HiveStandardAccreditation extends HiveObject {
  HiveStandardAccreditation();

  HiveStandardAccreditation.from(StandardAccreditation accreditation)
      : surveyYear = accreditation.surveyYear,
        districtCode = accreditation.districtCode,
        authorityCode = accreditation.authorityCode,
        authorityGovtCode = accreditation.authorityGovtCode,
        schoolTypeCode = accreditation.schoolTypeCode,
        standard = accreditation.standard,
        result = accreditation.result,
        total = accreditation.total,
        numInYear = accreditation.numThisYear;

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
  int total;

  @HiveField(8)
  int numInYear;

  StandardAccreditation toAccreditation() => StandardAccreditation(
        surveyYear: surveyYear,
        districtCode: districtCode,
        authorityCode: authorityCode,
        authorityGovtCode: authorityGovtCode,
        schoolTypeCode: schoolTypeCode,
        standard: standard,
        result: result,
        total: total,
        numThisYear: numInYear,
      );
}
