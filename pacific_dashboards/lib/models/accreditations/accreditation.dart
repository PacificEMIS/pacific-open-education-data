abstract class Accreditation {
  int get surveyYear;
  String get districtCode;
  String get authorityCode;
  String get authorityGovtCode;
  int get total;
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