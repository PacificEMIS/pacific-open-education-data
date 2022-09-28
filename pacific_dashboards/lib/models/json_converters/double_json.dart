import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'double_json.g.dart';

@JsonSerializable()
class DoubleJson{
  @JsonKey(name: '\$t')
  final String value;

  const DoubleJson({
    @required this.value,
  });

  factory DoubleJson.fromJson(Map<String, dynamic> json) {
    if (json == null){
      return null;
    }
    else {
      return _$DoubleJsonFromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$DoubleJsonToJson(this);

  static double doubleFromJson(Map<String, dynamic> doubleJson) {
    if (doubleJson == null){
      return null;
    }
    else {
      return double.parse(DoubleJson
          .fromJson(doubleJson)
          .value);
    }
  }

  static int intFromDoubleJson(Map<String, dynamic> doubleJson) {
    if (doubleJson == null){
      return null;
    }
    else {
      return double.parse(DoubleJson
          .fromJson(doubleJson)
          .value).round();
    }
  }

  static Map<String, dynamic> doubleToJson(double d) {
    if (d == null){
      return null;
    }
    else {
      return new DoubleJson(value: d.toString()).toJson();
    }
  }
}
