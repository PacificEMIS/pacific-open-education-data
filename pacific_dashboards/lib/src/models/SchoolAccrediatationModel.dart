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
  final String inspectionResult;
  final String result;
  final String standart;
  final String standartFull;
  final int numSum;
  final int numThisYear;
  final int numInYear;
  final int level1;
  final int level2;
  final int level3;
  final int level4;

  SchoolAccreditationModel({
    this.surveyYear,
    this.districtCode,
    this.district,
    this.authorityCode,
    this.authority,
    this.authorityGovtCode,
    this.authorityGovt,
    this.schoolTypeCode,
    this.schoolType,
    this.inspectionResult,
    this.result,
    this.numSum,
    this.numThisYear,
    this.numInYear,
    this.standart,
    this.standartFull,
    this.level1,
    this.level2,
    this.level3,
    this.level4,
  });

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
        inspectionResult: parsedJson['InspectionResult'] ?? "",
        result: parsedJson['Result'] ?? "",
        numSum: parsedJson['Num'] ?? 0,
        numThisYear: parsedJson['NumThisYear'] ?? 0,
        numInYear: parsedJson['NumInYear'] ?? 0,
        standart: parsedJson['Standard'] ?? "",
        standartFull:  parsedJson['Standard'] ?? "",
        level1: parsedJson['Level1'] ?? 0,
        level2: parsedJson['Level2'] ?? 0,
        level3: parsedJson['Level3'] ?? 0,
        level4: parsedJson['Level4'] ?? 0);
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
        'InspectionResult': inspectionResult,
        'Num': numSum,
        'NumThisYear': numThisYear,
        'NumInYear': numInYear,
        'Standard': standart
      };
}
