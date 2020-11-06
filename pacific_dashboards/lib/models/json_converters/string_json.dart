import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'string_json.g.dart';

@JsonSerializable()
class StringJson{
  @JsonKey(name: '\$t')
  final String value;

  const StringJson({
    @required this.value,
  });

  factory StringJson.fromJson(Map<String, dynamic> json) {
    if (json == null){
      return null;
    }
    else {
      return _$StringJsonFromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$StringJsonToJson(this);

  static String stringFromJson(Map<String, dynamic> stringJson) {
    if (stringJson == null){
      return null;
    }
    else {
      return StringJson.fromJson(stringJson).value;
    }
  }

  static Map<String, dynamic> stringToJson(String str) {
    if (str == null){
      return null;
    }
    else {
      return new StringJson(value: str).toJson();
    }
  }
}
