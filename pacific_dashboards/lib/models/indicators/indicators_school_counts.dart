import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_school_count.dart';

part 'indicators_school_counts.g.dart';

@JsonSerializable()
class IndicatorsSchoolCounts {
  @JsonKey(name: 'SchoolCount')
  final List<IndicatorsSchoolCount> schoolCounts;

  const IndicatorsSchoolCounts({
    @required this.schoolCounts,
  });

  factory IndicatorsSchoolCounts.fromJson(Map<String, dynamic> json) => _$IndicatorsSchoolCountsFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSchoolCountsToJson(this);
}