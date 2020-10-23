import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';

part 'question_lookup.g.dart';

@JsonSerializable()
class QuestionLookup extends Lookup {
  @JsonKey(name: 'QID')
  final String qId;

  @JsonKey(name: 'QName')
  final String qName;

  const QuestionLookup({
    @required String code,
    @required String name,
    @required this.qId,
    @required this.qName,
  }) : super(code: code, name: name);

  factory QuestionLookup.fromJson(Map<String, dynamic> json) =>
      _$QuestionLookupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QuestionLookupToJson(this);
}
