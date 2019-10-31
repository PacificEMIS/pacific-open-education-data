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

  int get enrolFemale => genderCode == 'F' ? enrol : 0;

  int get enrolMale => genderCode == 'M' ? enrol : 0;

  String get ageGroup => _getAgeGroup(age);

  SchoolModel({
    this.surveyYear,
    this.classLevel,
    this.districtCode,
    this.authorityCode,
    this.authorityGovt,
    this.schoolTypeCode,
    this.age,
    this.genderCode,
    this.enrol,
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
      genderCode: parsedJson['GenderCode'] ?? "",
      enrol: parsedJson['Enrol'] ?? 0,
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

  String _getAgeGroup(int age) {
    int ageCoeff = age ~/ 5 + 1;
    return '${((ageCoeff * 5) - 4)}-${(ageCoeff * 5)}';
  }
}
