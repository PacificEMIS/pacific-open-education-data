import 'package:json_annotation/json_annotation.dart';

part 'school_enroll.g.dart';

@JsonSerializable()
class SchoolEnroll {
  @JsonKey(name: 'SurveyYear', defaultValue: 0)
  int year;

  @JsonKey(name: 'ClassLevel', defaultValue: '')
  String classLevel;

  @JsonKey(name: 'EnrolF', defaultValue: 0)
  int enrollFemale;

  @JsonKey(name: 'EnrolM', defaultValue: 0)
  int enrollMale;

  @JsonKey(name: 'Enrol', defaultValue: 0)
  int totalEnroll;

  SchoolEnroll();

  factory SchoolEnroll.fromJson(Map<String, dynamic> json) =>
      _$SchoolEnrollFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolEnrollToJson(this);

  SchoolEnroll operator +(SchoolEnroll other) {
    return SchoolEnroll()
      ..year = year
      ..classLevel = classLevel
      ..enrollFemale = enrollFemale + other.enrollFemale
      ..enrollMale = enrollMale + other.enrollMale
      ..totalEnroll = totalEnroll + other.totalEnroll;
  }
}
