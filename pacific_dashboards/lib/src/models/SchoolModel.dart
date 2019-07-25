class SchoolModel {
  final int surveyYear;
  final String classLevel;
  final String districtCode;
  final String authorityCode;
  final String authorityGovt;
  final String schoolTypeCode;
  final int age;
  final String genderCode;
  final int enrol;
  String ageGroup;

  int get enrolF => genderCode == 'F' ? enrol : 0;
  int get enrolM => genderCode == 'M' ? enrol : 0;

  SchoolModel(
      {this.surveyYear,
      this.classLevel,
      this.districtCode,
      this.authorityCode,
      this.authorityGovt,
      this.schoolTypeCode,
      this.age,
      this.genderCode,
      this.enrol,
      this.ageGroup});

  factory SchoolModel.fromJson(Map parsedJson) {
    return SchoolModel(
      classLevel: parsedJson['ClassLevel'] ?? "",
      districtCode: parsedJson['DistrictCode'] ?? "",
      authorityCode: parsedJson['AuthorityCode'] ?? "",
      authorityGovt: parsedJson['AuthorityGovt'] ?? "",
      schoolTypeCode: parsedJson['SchoolTypeCode'] ?? "",
      surveyYear: parsedJson['SurveyYear'] ?? 0,
      age: parsedJson['Age'] ?? 0,
      genderCode: parsedJson['GenderCode'] ?? "",
      enrol: parsedJson['Enrol'] ?? 0,
      ageGroup: "",
    );
  }

  Map<String, dynamic> toJson() => {
        'ClassLevel': classLevel,
        'DistrictCode': districtCode,
        'AuthorityCode': authorityCode,
        'AuthorityGovt': authorityGovt,
        'SchoolTypeCode': schoolTypeCode,
        'SurveyYear': surveyYear,
        'Age': age,
        'GenderCode': genderCode,
        'Enrol': enrol,
      };
}
