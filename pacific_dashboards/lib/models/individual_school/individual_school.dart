import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/individual_accreditation/individual_accreditation.dart';

part 'individual_school.g.dart';

@JsonSerializable()
class IndividualSchool {
  const IndividualSchool({
    @required this.accreditationList,
  });

  factory IndividualSchool.fromJson(Map<String, dynamic> json) =>
      _$IndividualSchoolFromJson(json);

  @JsonKey(name: 'SchoolAccreditations')
  final List<IndividualAccreditation> accreditationList;

  Map<String, dynamic> toJson() => _$IndividualSchoolToJson(this);
}
