import 'package:flutter/material.dart';

class IndividualAccreditationData {
  final DateTime dateTime;
  final String inspectedBy;
  final int result;
  final List<AccreditationByStandard> standards;
  final int classroomObservation1;
  final int classroomObservation2;

  const IndividualAccreditationData({
    @required this.dateTime,
    @required this.inspectedBy,
    @required this.result,
    @required this.standards,
    @required this.classroomObservation1,
    @required this.classroomObservation2,
  });
}

class AccreditationByStandard {
  final String standard;
  final int result;
  final int criteria1;
  final int criteria2;
  final int criteria3;
  final int criteria4;

  const AccreditationByStandard({
    @required this.standard,
    @required this.result,
    @required this.criteria1,
    @required this.criteria2,
    @required this.criteria3,
    @required this.criteria4,
  });
}
