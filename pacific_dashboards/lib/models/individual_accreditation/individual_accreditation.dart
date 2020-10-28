import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'individual_accreditation.g.dart';

@JsonSerializable()
class IndividualAccreditation {

  @JsonKey(name: 'StartDate')
  final DateTime dateTime;

  @JsonKey(name: 'InspectionYear')
  final int inspectionYear;

  @JsonKey(name: 'InspectionResult')
  final String result;

  @JsonKey(name: 'SE.1')
  final double se_1;

  @JsonKey(name: 'SE.1.1')
  final double se_1_1;

  @JsonKey(name: 'SE.1.2')
  final double se_1_2;

  @JsonKey(name: 'SE.1.3')
  final double se_1_3;

  @JsonKey(name: 'SE.1.4')
  final double se_1_4;

  @JsonKey(name: 'SE.2')
  final double se_2;

  @JsonKey(name: 'SE.2.1')
  final double se_2_1;

  @JsonKey(name: 'SE.2.2')
  final double se_2_2;

  @JsonKey(name: 'SE.2.3')
  final double se_2_3;

  @JsonKey(name: 'SE.2.4')
  final double se_2_4;

  @JsonKey(name: 'SE.3')
  final double se_3;

  @JsonKey(name: 'SE.3.1')
  final double se_3_1;

  @JsonKey(name: 'SE.3.2')
  final double se_3_2;

  @JsonKey(name: 'SE.3.3')
  final double se_3_3;

  @JsonKey(name: 'SE.3.4')
  final double se_3_4;

  @JsonKey(name: 'SE.4')
  final double se_4;

  @JsonKey(name: 'SE.4.1')
  final double se_4_1;

  @JsonKey(name: 'SE.4.2')
  final double se_4_2;

  @JsonKey(name: 'SE.4.3')
  final double se_4_3;

  @JsonKey(name: 'SE.4.4')
  final double se_4_4;

  @JsonKey(name: 'SE.5')
  final double se_5;

  @JsonKey(name: 'SE.5.1')
  final double se_5_1;

  @JsonKey(name: 'SE.5.2')
  final double se_5_2;

  @JsonKey(name: 'SE.5.3')
  final double se_5_3;

  @JsonKey(name: 'SE.5.4')
  final double se_5_4;

  @JsonKey(name: 'SE.6')
  final double se_6;

  @JsonKey(name: 'SE.6.1')
  final double se_6_1;

  @JsonKey(name: 'SE.6.2')
  final double se_6_2;

  @JsonKey(name: 'SE.6.3')
  final double se_6_3;

  @JsonKey(name: 'SE.6.4')
  final double se_6_4;

  @JsonKey(name: 'CO.1')
  final double co_1;

  @JsonKey(name: 'CO.2')
  final double co_2;

  @JsonKey(name: 'InspectedBy')
  final String inspectedBy;


  const IndividualAccreditation({
    @required this.dateTime,
    @required this.inspectionYear,
    @required this.result,
    @required this.se_1,
    @required this.se_1_1,
    @required this.se_1_2,
    @required this.se_1_3,
    @required this.se_1_4,
    @required this.se_2,
    @required this.se_2_1,
    @required this.se_2_2,
    @required this.se_2_3,
    @required this.se_2_4,
    @required this.se_3,
    @required this.se_3_1,
    @required this.se_3_2,
    @required this.se_3_3,
    @required this.se_3_4,
    @required this.se_4,
    @required this.se_4_1,
    @required this.se_4_2,
    @required this.se_4_3,
    @required this.se_4_4,
    @required this.se_5,
    @required this.se_5_1,
    @required this.se_5_2,
    @required this.se_5_3,
    @required this.se_5_4,
    @required this.se_6,
    @required this.se_6_1,
    @required this.se_6_2,
    @required this.se_6_3,
    @required this.se_6_4,
    @required this.co_1,
    @required this.co_2,
    @required this.inspectedBy,
  });

  factory IndividualAccreditation.fromJson(Map<String, dynamic> json) =>
      _$IndividualAccreditationFromJson(json);

  Map<String, dynamic> toJson() => _$IndividualAccreditationToJson(this);

}