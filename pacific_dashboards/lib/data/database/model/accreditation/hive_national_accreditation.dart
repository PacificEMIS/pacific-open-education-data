import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/accreditations/national_accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/standard_accreditation.dart';

part 'hive_national_accreditation.g.dart';

@HiveType(typeId: 15)
class HiveNationalAccreditation extends HiveObject {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String districtCode;

  @HiveField(2)
  String district;

  @HiveField(3)
  String authorityCode;

  @HiveField(4)
  String authority;

  @HiveField(5)
  String authorityGovtCode;

  @HiveField(6)
  String authorityGovt;

  @HiveField(7)
  String schoolTypeCode;

  @HiveField(8)
  String schoolType;

  @HiveField(9)
  String inspectionResult;
  
  @HiveField(10)
  int total;

  @HiveField(11)
  int numThisYear;

  NationalAccreditation toAccreditation() => NationalAccreditation(
        surveyYear: surveyYear,
        districtCode: districtCode,
        district: district,
        authorityCode: authorityCode,
        authority: authority,
        authorityGovtCode: authorityGovtCode,
        authorityGovt: authorityGovt,
        schoolTypeCode: schoolTypeCode,
        schoolType: schoolType,
        inspectionResult: inspectionResult,
        total: total,
        numThisYear: numThisYear,
      );

  static HiveNationalAccreditation from(NationalAccreditation accreditation) =>
      HiveNationalAccreditation()
        ..surveyYear = accreditation.surveyYear
        ..districtCode = accreditation.districtCode
        ..district = accreditation.district
        ..authorityCode = accreditation.authorityCode
        ..authority = accreditation.authority
        ..authorityGovtCode = accreditation.authorityGovtCode
        ..authorityGovt = accreditation.authorityGovt
        ..schoolTypeCode = accreditation.schoolTypeCode
        ..schoolType = accreditation.schoolType
        ..inspectionResult = accreditation.inspectionResult
        ..total = accreditation.total
        ..numThisYear = accreditation.numThisYear;
}
