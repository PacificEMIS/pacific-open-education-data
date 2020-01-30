import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'district_accreditation.g.dart';

abstract class DistrictAccreditation
    implements
        Built<DistrictAccreditation, DistrictAccreditationBuilder>,
        Accreditation {
  DistrictAccreditation._();

  factory DistrictAccreditation([updates(DistrictAccreditationBuilder b)]) =
      _$DistrictAccreditation;

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
  @BuiltValueField(wireName: 'InspectionResult')
  String get inspectionResult;

  @override
  @nullable
  @BuiltValueField(wireName: 'Num')
  int get num;

  @override
  @nullable
  @BuiltValueField(wireName: 'NumThisYear')
  int get numThisYear;

  @override
  String get result => inspectionResult;

  @override
  Comparable get sortField => "";

  String toJson() {
    return json.encode(
        serializers.serializeWith(DistrictAccreditation.serializer, this));
  }

  static DistrictAccreditation fromJson(String jsonString) {
    return serializers.deserializeWith(
        DistrictAccreditation.serializer, json.decode(jsonString));
  }

  static Serializer<DistrictAccreditation> get serializer =>
      _$districtAccreditationSerializer;
}
