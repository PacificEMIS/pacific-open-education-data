import 'package:flutter/foundation.dart';

class WashToiletViewData {
  const WashToiletViewData({
    @required this.totalToilets,
    @required this.usableToilets,
    @required this.usablePercent,
    @required this.usablePercentByGender,
    @required this.pupilsByToilet,
    @required this.pupilsByToiletByGender,
    @required this.pupilsByUsableToilet,
    @required this.pupilsByUsableToiletByGender,
    @required this.pupils,
  });

  final List<SchoolDataByToiletType> totalToilets;
  final List<SchoolDataByToiletType> usableToilets;
  final List<SchoolDataByPercent> usablePercent;
  final List<SchoolDataByGenderPercent> usablePercentByGender;
  final List<SchoolDataByPupils> pupilsByToilet;
  final List<SchoolDataByGender> pupilsByToiletByGender;
  final List<SchoolDataByPupils> pupilsByUsableToilet;
  final List<SchoolDataByGender> pupilsByUsableToiletByGender;
  final List<SchoolDataByGender> pupils;
}

class SchoolDataByToiletType {
  const SchoolDataByToiletType({
    @required this.school,
    @required this.boys,
    @required this.girls,
    @required this.common,
  });

  final String school;
  final int boys;
  final int girls;
  final int common;
}

class SchoolDataByPercent {
  const SchoolDataByPercent({
    @required this.school,
    @required this.percent,
  });

  final String school;
  final int percent;
}

class SchoolDataByGenderPercent {
  const SchoolDataByGenderPercent({
    @required this.school,
    @required this.percentMale,
    @required this.percentFemale,
  });

  final String school;
  final int percentMale;
  final int percentFemale;
}

class SchoolDataByPupils {
  const SchoolDataByPupils({
    @required this.school,
    @required this.pupils,
  });

  final String school;
  final int pupils;
}

class SchoolDataByGender {
  const SchoolDataByGender({
    @required this.school,
    @required this.male,
    @required this.female,
  });

  final String school;
  final int male;
  final int female;
}
