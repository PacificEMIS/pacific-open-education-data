import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lookup.g.dart';

@JsonSerializable()
class Lookup {
  const Lookup({
    @required this.code,
    @required this.name,
  });

  factory Lookup.fromJson(Map<String, dynamic> json) => _$LookupFromJson(json);

  @JsonKey(name: 'C')
  final String code;

  @JsonKey(name: 'N')
  final String name;

  Map<String, dynamic> toJson() => _$LookupToJson(this);
}
