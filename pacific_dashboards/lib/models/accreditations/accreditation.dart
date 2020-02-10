abstract class Accreditation {
// ignore: unused_field
  static const _kYearFilterId = 0;
  // ignore: unused_field
  static const _kDistrictFilterId = 1;
  // ignore: unused_field
  static const _kAuthorityFilterId = 2;
  // ignore: unused_field
  static const _kGovtFilterId = 3;

  int get surveyYear;
  String get districtCode;
  String get authorityCode;
  String get authorityGovtCode;
  int get num;
  int get numThisYear;
  String get result;
  Comparable get sortField;
}

enum AccreditationLevel { level1, level2, level3, level4, undefined }

extension AccreditationExt on Accreditation {
  AccreditationLevel get level {
    switch (result) {
      case "Level 1":
        return AccreditationLevel.level1;
      case "Level 2":
        return AccreditationLevel.level2;
      case "Level 3":
        return AccreditationLevel.level3;
      case "Level 4":
        return AccreditationLevel.level4;
      default:
        return AccreditationLevel.undefined;
    }
  }
}