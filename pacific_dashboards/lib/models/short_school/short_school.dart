import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'short_school.g.dart';

@JsonSerializable()
class ShortSchool {
  const ShortSchool({
    @required this.id,
    @required this.name,
    @required this.districtCode,
    @required this.districtName,
  });

  factory ShortSchool.fromJson(Map<String, dynamic> json) =>
      _$ShortSchoolFromJson(json);

  @JsonKey(name: 'schNo')
  final String id;

  @JsonKey(name: 'schName')
  final String name;

  @JsonKey(name: 'iGroup')
  final String districtCode;

  @JsonKey(name: 'dName')
  final String districtName;

  Map<String, dynamic> toJson() => _$ShortSchoolToJson(this);
}
