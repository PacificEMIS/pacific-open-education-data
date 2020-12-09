import 'package:flutter/material.dart';

@immutable
class IndividualAccreditationData {
  const IndividualAccreditationData({
    @required this.dateTime,
    @required this.inspectionYear,
    @required this.inspectedBy,
    @required this.result,
    @required this.standards,
    @required this.classroomObservation1,
    @required this.classroomObservation2,
  });

  final DateTime dateTime;
  final int inspectionYear;
  final String inspectedBy;
  final int result;
  final List<AccreditationByStandard> standards;
  final int classroomObservation1;
  final int classroomObservation2;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndividualAccreditationData &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          inspectionYear == other.inspectionYear &&
          inspectedBy == other.inspectedBy &&
          result == other.result &&
          standards == other.standards &&
          classroomObservation1 == other.classroomObservation1 &&
          classroomObservation2 == other.classroomObservation2;

  @override
  int get hashCode =>
      dateTime.hashCode ^
      inspectionYear.hashCode ^
      inspectedBy.hashCode ^
      result.hashCode ^
      standards.hashCode ^
      classroomObservation1.hashCode ^
      classroomObservation2.hashCode;
}

@immutable
class AccreditationByStandard {
  const AccreditationByStandard({
    @required this.standard,
    @required this.result,
    @required this.criteria1,
    @required this.criteria2,
    @required this.criteria3,
    @required this.criteria4,
  });

  final String standard;
  final int result;
  final int criteria1;
  final int criteria2;
  final int criteria3;
  final int criteria4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccreditationByStandard &&
          runtimeType == other.runtimeType &&
          standard == other.standard &&
          result == other.result &&
          criteria1 == other.criteria1 &&
          criteria2 == other.criteria2 &&
          criteria3 == other.criteria3 &&
          criteria4 == other.criteria4;

  @override
  int get hashCode =>
      standard.hashCode ^
      result.hashCode ^
      criteria1.hashCode ^
      criteria2.hashCode ^
      criteria3.hashCode ^
      criteria4.hashCode;
}
