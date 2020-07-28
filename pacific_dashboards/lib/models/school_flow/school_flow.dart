
import 'package:json_annotation/json_annotation.dart';

part 'school_flow.g.dart';

@JsonSerializable()
class SchoolFlow {
  @JsonKey(name: 'SurveyYear')
  int year;

  @JsonKey(name: 'YearOfEd')
  int yearOfEducation;

  @JsonKey(name: 'RepeatRate')
  double repeatRate;

  @JsonKey(name: 'PromoteRate')
  double promoteRate;

  @JsonKey(name: 'DropoutRate')
  double dropoutRate;

  @JsonKey(name: 'SurvivalRate')
  double survivalRate;

  SchoolFlow();

  factory SchoolFlow.fromJson(Map<String, dynamic> json) =>
      _$SchoolFlowFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolFlowToJson(this);
}