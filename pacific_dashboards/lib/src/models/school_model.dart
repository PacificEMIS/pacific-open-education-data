class SchoolModel {
  final int surveyYear;
  final String classLevel;
  final String districtCode;
  final String authorityCode;
  final String authorityGovt;
  final String schoolTypeCode;
  final int age;
  final int enrolM;
  final int enrolF;

  SchoolModel({
    this.surveyYear,
    this.classLevel,
    this.districtCode,
    this.authorityCode,
    this.authorityGovt,
    this.schoolTypeCode,
    this.age,
    this.enrolM,
    this.enrolF,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> parsedJson) {
    return SchoolModel(
      classLevel: parsedJson['ClassLevel'],
      districtCode: parsedJson['DistrictCode'],
      authorityCode: parsedJson['AuthorityCode'],
      authorityGovt: parsedJson['AuthorityGovt'],
      schoolTypeCode: parsedJson['SchoolTypeCode'],
      surveyYear: parsedJson['SurveyYear'] ?? 0,
      age: parsedJson['Age'] ?? 0,
      enrolM: parsedJson['EnrolM'] ?? 0,
      enrolF: parsedJson['EnrolF'] ?? 0,
    );
  }
}