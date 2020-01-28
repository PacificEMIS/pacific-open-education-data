import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'school.g.dart';

abstract class School implements Built<School, SchoolBuilder> {
  School._();

  factory School([updates(SchoolBuilder b)]) = _$School;

  @BuiltValueField(wireName: 'SurveyYear')
  int get surveyYear;

  @BuiltValueField(wireName: 'ClassLevel')
  String get classLevel;

  @nullable
  @BuiltValueField(wireName: 'Age')
  int get age;

  @BuiltValueField(wireName: 'DistrictCode')
  String get districtCode;

  @BuiltValueField(wireName: 'AuthorityCode')
  String get authorityCode;

  @BuiltValueField(wireName: 'AuthorityGovt')
  String get authorityGovt;

  @BuiltValueField(wireName: 'GenderCode')
  String get genderCode;

  @BuiltValueField(wireName: 'SchoolTypeCode')
  String get schoolTypeCode;

  @nullable
  @BuiltValueField(wireName: 'Enrol')
  int get enrol;

  Gender get gender {
    switch (genderCode) {
      case 'M':
        return Gender.male;
      default:
        return Gender.female;
    }
  }

  String get ageGroup {
    if (age == null) {
      return "no age";
    }

    int ageCoeff = age ~/ 5 + 1;
    return '${((ageCoeff * 5) - 4)}-${(ageCoeff * 5)}';
  }

  String toJson() {
    return json.encode(serializers.serializeWith(School.serializer, this));
  }

  static School fromJson(String jsonString) {
    return serializers.deserializeWith(
        School.serializer, json.decode(jsonString));
  }

  static Serializer<School> get serializer => _$schoolSerializer;
}

enum EducationLevel { all, earlyChildhood, primary, secondary, postSecondary }

extension EducationLevelCodes on EducationLevel {
  String get levelCode {
    switch (this) {
      case EducationLevel.all:
        return null;
      case EducationLevel.earlyChildhood:
        return 'ECE';
      case EducationLevel.primary:
        return 'PRI';
      case EducationLevel.secondary:
        return 'SEC';
      case EducationLevel.postSecondary:
        return 'PSE';
    }
    throw FallThroughError();
  }
}
