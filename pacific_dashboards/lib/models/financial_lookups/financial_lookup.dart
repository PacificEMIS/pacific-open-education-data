import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'financial_lookup.g.dart';

@JsonSerializable()
class FinancialLookup {
  const FinancialLookup({
    @required this.code,
    @required this.name,
  });

  factory FinancialLookup.fromJson(Map<String, dynamic> json) =>
      _$FinancialLookupFromJson(json);

  @JsonKey(name: 'C')
  final String code;

  @JsonKey(name: 'N')
  final String name;

  Map<String, dynamic> toJson() => _$FinancialLookupToJson(this);
}
