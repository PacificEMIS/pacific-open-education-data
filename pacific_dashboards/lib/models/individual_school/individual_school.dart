import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/individual_accreditation/individual_accreditation.dart';

part 'individual_school.g.dart';

@JsonSerializable()
class IndividualSchool {

  @JsonKey(name: 'SchoolAccreditations')
  final List<IndividualAccreditation> accreditationList;

  const IndividualSchool({
    @required this.accreditationList,
  });

  factory IndividualSchool.fromJson(Map<String, dynamic> json) =>
      _$IndividualSchoolFromJson(json);

  Map<String, dynamic> toJson() => _$IndividualSchoolToJson(this);

}