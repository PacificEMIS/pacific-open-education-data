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

  @BuiltValueField(wireName: 'CandidatesM')
  int get candidatesM;

  @nullable
  @BuiltValueField(wireName: '1M')
  int get wellBelowCompetentM;

  @nullable
  @BuiltValueField(wireName: 'ApproachingCompetenceM')
  int get approachingCompetenceM;

  @nullable
  @BuiltValueField(wireName: 'MinimallyCompetentM')
  int get minimallyCompetentM;

  @nullable
  @BuiltValueField(wireName: 'CompetentM')
  int get competentM;

  @nullable
  @BuiltValueField(wireName: 'CandidatesF')
  int get candidatesF;

  @nullable
  @BuiltValueField(wireName: 'WellBelowCompetentF')
  int get wellBelowCompetentF;

  @nullable
  @BuiltValueField(wireName: 'ApproachingCompetenceF')
  int get approachingCompetenceF;

  @nullable
  @BuiltValueField(wireName: 'MinimallyCompetentF')
  int get minimallyCompetentF;

  @nullable
  @BuiltValueField(wireName: 'CompetentF')
  int get competentF;

  Exam operator +(Exam other) {
    return this.rebuild(
      (b) => b
        ..candidatesM = (candidatesM ?? 0) + (other.candidatesM ?? 0)
        ..wellBelowCompetentM = (wellBelowCompetentM ?? 0) + (other.wellBelowCompetentM ?? 0)
        ..approachingCompetenceM =
        (approachingCompetenceM ?? 0) + (other.approachingCompetenceM ?? 0)
        ..minimallyCompetentM = (minimallyCompetentM ?? 0) + (other.minimallyCompetentM ?? 0)
        ..competentM = (competentM ?? 0) + (other.competentM ?? 0)
        ..candidatesF = (candidatesF ?? 0) + (other.candidatesF ?? 0)
        ..wellBelowCompetentF = (wellBelowCompetentF ?? 0) + (other.wellBelowCompetentF ?? 0)
        ..approachingCompetenceF =
        (approachingCompetenceF ?? 0) + (other.approachingCompetenceF ?? 0)
        ..minimallyCompetentF = (minimallyCompetentF ?? 0) + (other.minimallyCompetentF ?? 0)
        ..competentF = (competentF ?? 0) + (other.competentF ?? 0),
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
