import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';

part 'hive_wash_total.g.dart';

@HiveType(typeId: 19)
class HiveWashTotal extends HiveObject with Expirable {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String districtCode;

  @HiveField(2)
  String district;

  @HiveField(3)
  String authorityCode;

  @HiveField(4)
  String authority;

  @HiveField(5)
  String authorityGroupCode;

  @HiveField(6)
  String authorityGroup;

  @HiveField(7)
  String schoolTypeCode;

  @HiveField(8)
  String schoolType;

  @HiveField(9)
  String question;

  @HiveField(10)
  String answer;

  @HiveField(11)
  String response;

  @HiveField(12)
  int number;

  @HiveField(13)
  int numThisYear;

  Wash toWash() => Wash(
        surveyYear,
        districtCode,
        district,
        authorityCode,
        authority,
        authorityGroupCode,
        authorityGroup,
        schoolTypeCode,
        schoolType,
        question,
        answer,
        response,
        number,
        numThisYear,
      );

  static HiveWashTotal from(Wash wash) => HiveWashTotal()
    ..surveyYear = wash.surveyYear
    ..districtCode = wash.districtCode
    ..district = wash.district
    ..authorityCode = wash.authorityCode
    ..authority = wash.authority
    ..authorityGroupCode = wash.authorityGroupCode
    ..authorityGroup = wash.authorityGroup
    ..schoolTypeCode = wash.schoolTypeCode
    ..schoolType = wash.schoolType
    ..question = wash.question
    ..answer = wash.answer
    ..response = wash.response
    ..number = wash.number
    ..numThisYear = wash.numThisYear;
}
