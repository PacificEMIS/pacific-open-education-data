import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';

part 'individual_school_response.g.dart';

@JsonSerializable()
class IndividualSchoolResponse {

  @JsonKey(name: 'ResultSet')
  final IndividualSchool school;

  const IndividualSchoolResponse({
    @required this.school,
  });

  factory IndividualSchoolResponse.fromJson(Map<String, dynamic> json) =>
      _$IndividualSchoolResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IndividualSchoolResponseToJson(this);

}