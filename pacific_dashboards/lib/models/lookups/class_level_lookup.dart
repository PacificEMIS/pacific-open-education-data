import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';

part 'class_level_lookup.g.dart';

@JsonSerializable()
class ClassLevelLookup extends Lookup {
  const ClassLevelLookup({
    @required String code,
    @required String name,
    @required this.l,
    @required this.yearOfEducation,
  }) : super(code: code, name: name);

  factory ClassLevelLookup.fromJson(Map<String, dynamic> json) =>
      _$ClassLevelLookupFromJson(json);

  @JsonKey(name: 'L')
  final String l;

  @JsonKey(name: 'YoEd')
  final int yearOfEducation;

  @override
  Map<String, dynamic> toJson() => _$ClassLevelLookupToJson(this);
}
