import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators.dart';

part 'indicators_container.g.dart';

@JsonSerializable()
class IndicatorsContainer {
  @JsonKey(name: 'VERM')
  final Indicators indicators;

  const IndicatorsContainer({
    @required this.indicators,
  });

  factory IndicatorsContainer.fromJson(Map<String, dynamic> json) => _$IndicatorsContainerFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsContainerToJson(this);
}