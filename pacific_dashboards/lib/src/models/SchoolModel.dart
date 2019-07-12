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
  int numTeachersM;
  int numTeachersF;
  final String genderCode;
  final int enrol;
  String ageGroup;

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
    this.numTeachersM,
    this.numTeachersF,
    this.genderCode,
    this.enrol,
    this.ageGroup
  });

  factory SchoolModel.fromJson(Map parsedJson) {
    return SchoolModel(
      classLevel: parsedJson['ClassLevel'] ?? "",
      districtCode: parsedJson['DistrictCode'] ?? "",
      authorityCode: parsedJson['AuthorityCode'] ?? "",
      authorityGovt: parsedJson['AuthorityGovt'] ?? "",
      schoolTypeCode: parsedJson['SchoolTypeCode'] ?? "",
      surveyYear: parsedJson['SurveyYear'] ?? 0,
      age: parsedJson['Age'] ?? 0,
      enrolM: parsedJson['EnrolM'] ?? 0,
      enrolF: parsedJson['EnrolF'] ?? 0,
      numTeachersM: parsedJson['NumTeachersM'] ?? 0,
      numTeachersF: parsedJson['NumTeachersF'] ?? 0,
      genderCode: parsedJson['GenderCode'] ?? "",
      enrol: parsedJson['Enrol'] ?? 0,
      ageGroup: "",
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'ClassLevel': classLevel,
        'DistrictCode': districtCode,
        'AuthorityCode': authorityCode,
        'AuthorityGovt' : authorityGovt,
        'SchoolTypeCode' : schoolTypeCode,
        'SurveyYear' : surveyYear,
        'Age' : age,
        'EnrolM' : enrolM,
        'EnrolF' : enrolF,
        'NumTeachersM' : numTeachersM,
        'NumTeachersF' : numTeachersF,
        'GenderCode' : genderCode,
        'Enrol' : enrol,
      };
}