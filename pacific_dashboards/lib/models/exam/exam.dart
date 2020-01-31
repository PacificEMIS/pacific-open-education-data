import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pacific_dashboards/models/serialized/serializers.dart';

part 'exam.g.dart';

abstract class Exam implements Built<Exam, ExamBuilder> {
  Exam._();

  factory Exam([updates(ExamBuilder b)]) = _$Exam;

  @BuiltValueField(wireName: 'Exam')
  String get name;

  @BuiltValueField(wireName: 'ExamYear')
  int get year;

  @BuiltValueField(wireName: 'DistrictCode')
  String get districtCode;

  @BuiltValueField(wireName: 'ExamStandard')
  String get standard;

  @BuiltValueField(wireName: 'ExamBenchmark')
  String get benchmark;

  @nullable
  @BuiltValueField(wireName: 'CandidatesM')
  int get candidatesMOptional;

  @nullable
  @BuiltValueField(wireName: '1M')
  int get wellBelowCompetentMOptional;

  @nullable
  @BuiltValueField(wireName: 'ApproachingCompetenceM')
  int get approachingCompetenceMOptional;

  @nullable
  @BuiltValueField(wireName: 'MinimallyCompetentM')
  int get minimallyCompetentMOptional;

  @nullable
  @BuiltValueField(wireName: 'CompetentM')
  int get competentMOptional;

  @nullable
  @BuiltValueField(wireName: 'CandidatesF')
  int get candidatesFOptional;

  @nullable
  @BuiltValueField(wireName: 'WellBelowCompetentF')
  int get wellBelowCompetentFOptional;

  @nullable
  @BuiltValueField(wireName: 'ApproachingCompetenceF')
  int get approachingCompetenceFOptional;

  @nullable
  @BuiltValueField(wireName: 'MinimallyCompetentF')
  int get minimallyCompetentFOptional;

  @nullable
  @BuiltValueField(wireName: 'CompetentF')
  int get competentFOptional;

  int get candidatesM => candidatesMOptional ?? 0;

  int get wellBelowCompetentM => wellBelowCompetentMOptional ?? 0;

  int get approachingCompetenceM => approachingCompetenceMOptional ?? 0;

  int get minimallyCompetentM => minimallyCompetentMOptional ?? 0;

  int get competentM => competentMOptional ?? 0;

  int get candidatesF => candidatesFOptional ?? 0;

  int get wellBelowCompetentF => wellBelowCompetentFOptional ?? 0;

  int get approachingCompetenceF => approachingCompetenceFOptional ?? 0;

  int get minimallyCompetentF => minimallyCompetentFOptional ?? 0;

  int get competentF => competentFOptional ?? 0;

  Exam operator +(Exam other) {
    return this.rebuild(
      (b) => b
        ..candidatesMOptional = candidatesM + other.candidatesM
        ..wellBelowCompetentMOptional = wellBelowCompetentM + other.wellBelowCompetentM
        ..approachingCompetenceMOptional =
            approachingCompetenceM + other.approachingCompetenceM
        ..minimallyCompetentMOptional = minimallyCompetentM + other.minimallyCompetentM
        ..competentMOptional = competentM + other.competentM
        ..candidatesFOptional = candidatesF + other.candidatesF
        ..wellBelowCompetentFOptional = wellBelowCompetentF + other.wellBelowCompetentF
        ..approachingCompetenceFOptional =
            approachingCompetenceF + other.approachingCompetenceF
        ..minimallyCompetentFOptional = minimallyCompetentF + other.minimallyCompetentF
        ..competentFOptional = competentF + other.competentF,
    );
  }

  String toJson() {
    return json.encode(serializers.serializeWith(Exam.serializer, this));
  }

  static Exam fromJson(String jsonString) {
    return serializers.deserializeWith(
        Exam.serializer, json.decode(jsonString));
  }

  static Serializer<Exam> get serializer => _$examSerializer;
}
