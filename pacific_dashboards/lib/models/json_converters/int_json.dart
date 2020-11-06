import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'int_json.g.dart';

@JsonSerializable()
class IntJson{
  @JsonKey(name: '\$t')
  final String value;

  const IntJson({
    @required this.value,
  });

  factory IntJson.fromJson(Map<String, dynamic> json) {
    if (json == null){
      return null;
    }
    else {
      return _$IntJsonFromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$IntJsonToJson(this);

  static int intFromJson(Map<String, dynamic> doubleJson) {
    if (doubleJson == null){
      return null;
    }
    else {
      return int.parse(IntJson
          .fromJson(doubleJson)
          .value);
    }
  }

  static Map<String, dynamic> intToJson(int i) {
    if (i == null){
      return null;
    }
    else {
      return new IntJson(value: i.toString()).toJson();
    }
  }
}
