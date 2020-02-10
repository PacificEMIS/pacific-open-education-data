library standard_accreditation;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'standard_accreditation.g.dart';

abstract class StandardAccreditation
    implements Built<StandardAccreditation, StandardAccreditationBuilder>, Accreditation {
  StandardAccreditation._();

  factory StandardAccreditation([updates(StandardAccreditationBuilder b)]) =
      _$StandardAccreditation;

  @override
  @BuiltValueField(wireName: 'SurveyYear')
  int get surveyYear;

  @override
  @BuiltValueField(wireName: 'DistrictCode')
  String get districtCode;

  @override
  @BuiltValueField(wireName: 'AuthorityCode')
  String get authorityCode;

  @override
  @BuiltValueField(wireName: 'AuthorityGovtCode')
  String get authorityGovtCode;

  @BuiltValueField(wireName: 'SchoolTypeCode')
  String get schoolTypeCode;

  @nullable
  @BuiltValueField(wireName: 'Standard')
  String get standard;

  @override
  @nullable
  @BuiltValueField(wireName: 'Result')
  String get result;

  @override
  @nullable
  @BuiltValueField(wireName: 'Num')
  int get num;

  @nullable
  @BuiltValueField(wireName: 'NumInYear')
  int get numInYear;

  @override
  int get numThisYear => numInYear;

  @override
  Comparable get sortField => standard ?? "";

  String toJson() {
    return json.encode(
        serializers.serializeWith(StandardAccreditation.serializer, this));
  }

  static StandardAccreditation fromJson(String jsonString) {
    return serializers.deserializeWith(
        StandardAccreditation.serializer, json.decode(jsonString));
  }

  static Serializer<StandardAccreditation> get serializer =>
      _$standardAccreditationSerializer;
}
