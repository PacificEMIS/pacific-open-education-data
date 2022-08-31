import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';

import 'indicators_sector_by_level.dart';

part 'indicators_sectors_by_level.g.dart';

@JsonSerializable()
class IndicatorsSectorsByLevel {
  @JsonKey(name: 'Sector', defaultValue: [])
  final List<IndicatorsSectorByLevel> sectors;

  const IndicatorsSectorsByLevel({
    @required this.sectors,
  });

  factory IndicatorsSectorsByLevel.fromJson(Map<String, dynamic> json) =>
      _$IndicatorsSectorsByLevelFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsSectorsByLevelToJson(this);
}