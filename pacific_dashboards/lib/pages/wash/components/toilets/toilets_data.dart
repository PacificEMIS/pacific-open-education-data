import 'package:flutter/foundation.dart';

class WashToiletViewData {
  final List<SchoolDataByToiletType> totalToilets;
  final List<SchoolDataByToiletType> usableToilets;
  final List<SchoolDataByPercent> usablePercent;
  final List<SchoolDataByGenderPercent> usablePercentByGender;
  final List<SchoolDataByPupils> pupilsByToilet;
  final List<SchoolDataByGender> pupilsByToiletByGender;
  final List<SchoolDataByPupils> pupilsByUsableToilet;
  final List<SchoolDataByGender> pupilsByUsableToiletByGender;
  final List<SchoolDataByGender> pupils;

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
}

class SchoolDataByToiletType {
  final String school;
  final int boys;
  final int girls;
  final int common;

  const SchoolDataByToiletType({
    @required this.school,
    @required this.boys,
    @required this.girls,
    @required this.common,
  });
}

class SchoolDataByPercent {
  final String school;
  final int percent;

  const SchoolDataByPercent({
    @required this.school,
    @required this.percent,
  });
}

class SchoolDataByGenderPercent {
  final String school;
  final int percentMale;
  final int percentFemale;

  const SchoolDataByGenderPercent({
    @required this.school,
    @required this.percentMale,
    @required this.percentFemale,
  });
}

class SchoolDataByPupils {
  final String school;
  final int pupils;

  const SchoolDataByPupils({
    @required this.school,
    @required this.pupils,
  });
}

class SchoolDataByGender {
  final String school;
  final int male;
  final int female;

  const SchoolDataByGender({
    @required this.school,
    @required this.male,
    @required this.female,
  });
}