class SchoolAccreditationModel {
  final int surveyYear;
  final String districtCode;
  final String district;
  final String authorityCode;
  final String authority;
  final String authorityGovtCode;
  final String authorityGovt;
  final String schoolTypeCode;
  final String schoolType;
  final String result;
  final String standard;
  final int numSum;
  final int numInYear;

  SchoolAccreditationModel(
      {this.surveyYear,
      this.districtCode,
      this.district,
      this.authorityCode,
      this.authority,
      this.authorityGovtCode,
      this.authorityGovt,
      this.schoolTypeCode,
      this.schoolType,
      this.result,
      this.numSum,
      this.numInYear,
      this.standard});

  factory SchoolAccreditationModel.fromJson(Map parsedJson) {
    return SchoolAccreditationModel(
        surveyYear: parsedJson['SurveyYear'] ?? 0,
        districtCode: parsedJson['DistrictCode'] ?? "",
        district: parsedJson['District'] ?? "",
        authorityCode: parsedJson['AuthorityCode'] ?? "",
        authority: parsedJson['Authority'] ?? "",
        authorityGovtCode: parsedJson['AuthorityGovtCode'] ?? "",
        authorityGovt: parsedJson['AuthorityGovt'] ?? "",
        schoolTypeCode: parsedJson['SchoolTypeCode'] ?? "",
        schoolType: parsedJson['SchoolType'] ?? "",
        result: parsedJson['Result'] ?? parsedJson['InspectionResult'] ?? "",
        numSum: parsedJson['Num'] ?? 0,
        numInYear: parsedJson['NumInYear'] ?? parsedJson['NumThisYear'] ?? 0,
        standard: parsedJson['Standard'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'SurveyYear': surveyYear,
        'DistrictCode': districtCode,
        'District': district,
        'AuthorityCode': authorityCode,
        'Authority': authority,
        'AuthorityGovtCode': authorityGovtCode,
        'AuthorityGovt': authorityGovt,
        'SchoolTypeCode': schoolTypeCode,
        'SchoolType': schoolType,
        'Result': result,
        'Num': numSum,
        'NumInYear': numInYear,
        'Standard': standard
      };

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

enum AccreditationLevel { level1, level2, level3, level4, undefined }
