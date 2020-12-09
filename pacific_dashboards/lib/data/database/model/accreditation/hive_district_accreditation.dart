import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/accreditations/district_accreditation.dart';

part 'hive_district_accreditation.g.dart';

@HiveType(typeId: 5)
class HiveDistrictAccreditation extends HiveObject {
  HiveDistrictAccreditation();

  HiveDistrictAccreditation.from(DistrictAccreditation accreditation)
      : surveyYear = accreditation.surveyYear,
        districtCode = accreditation.districtCode,
        authorityCode = accreditation.authorityCode,
        authorityGovtCode = accreditation.authorityGovtCode,
        schoolTypeCode = accreditation.schoolTypeCode,
        inspectionResult = accreditation.inspectionResult,
        total = accreditation.total,
        numThisYear = accreditation.numThisYear;

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
  String inspectionResult;

  @HiveField(6)
  int total;

  @HiveField(7)
  int numThisYear;

  DistrictAccreditation toAccreditation() => DistrictAccreditation(
        surveyYear: surveyYear,
        districtCode: districtCode,
        authorityCode: authorityCode,
        authorityGovtCode: authorityGovtCode,
        schoolTypeCode: schoolTypeCode,
        inspectionResult: inspectionResult,
        total: total,
        numThisYear: numThisYear,
      );
}
