import 'package:flutter/material.dart';

class ChartData {
  final String domain;
  final num measure;
  final Color color;

  const ChartData(this.domain, this.measure, this.color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartData &&
          runtimeType == other.runtimeType &&
          domain == other.domain &&
          measure == other.measure &&
          color == other.color;

  @override
  int get hashCode => domain.hashCode ^ measure.hashCode ^ color.hashCode;
}
