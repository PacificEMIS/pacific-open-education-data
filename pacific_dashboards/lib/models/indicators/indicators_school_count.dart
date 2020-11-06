import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/json_converters/int_json.dart';

part 'indicators_school_count.g.dart';

@JsonSerializable()
class IndicatorsSchoolCount {
  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'schoolType')
  final String schoolType;

  @JsonKey(name: 'count',
      toJson: IntJson.intToJson,
      fromJson: IntJson.intFromJson,
      includeIfNull: false)
  final int count;


  const IndicatorsSchoolCount({
    @required this.year,
    this.schoolType,
    this.count,
  });

  factory IndicatorsSchoolCount.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsSchoolCountFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSchoolCountToJson(this);
}