import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lookup.g.dart';

@JsonSerializable()
class Lookup {
  @JsonKey(name: 'C', defaultValue: '')
  final String code;

  @JsonKey(name: 'N', defaultValue: '')
  final String name;

  const Lookup({
    @required this.code,
    @required this.name,
  });

  factory Lookup.fromJson(Map<String, dynamic> json) => _$LookupFromJson(json);

  Map<String, dynamic> toJson() => _$LookupToJson(this);
}
