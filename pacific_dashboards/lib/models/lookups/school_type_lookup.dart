import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'school_type_lookup.g.dart';

@JsonSerializable()
class SchoolTypeLookup {
  @JsonKey(name: 'ST')
  final String schoolCode;

  @JsonKey(name: 'L')
  final String level;

  @JsonKey(name: 'YoEd')
  final int yearOfEducation;

  const SchoolTypeLookup({
    @required this.schoolCode,
    @required this.level,
    @required this.yearOfEducation,
  });

  factory SchoolTypeLookup.fromJson(Map<String, dynamic> json) =>
      _$SchoolTypeLookupFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolTypeLookupToJson(this);
}
