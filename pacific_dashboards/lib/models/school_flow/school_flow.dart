
import 'package:json_annotation/json_annotation.dart';

part 'school_flow.g.dart';

@JsonSerializable()
class SchoolFlow {
  @JsonKey(name: 'SurveyYear')
  int year;

  @JsonKey(name: 'YearOfEd')
  int yearOfEducation;

  @JsonKey(name: 'RepeatRate', defaultValue: 0.0)
  double repeatRate;

  @JsonKey(name: 'PromoteRate', defaultValue: 0.0)
  double promoteRate;

  @JsonKey(name: 'DropoutRate', defaultValue: 0.0)
  double dropoutRate;

  @JsonKey(name: 'SurvivalRate', defaultValue: 0.0)
  double survivalRate;

  SchoolFlow();

  factory SchoolFlow.fromJson(Map<String, dynamic> json) =>
      _$SchoolFlowFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolFlowToJson(this);
}