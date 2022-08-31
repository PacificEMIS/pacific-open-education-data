import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_education_year.dart';
import 'indicators_enrolment_by_level.dart';
import 'indicators_school_count.dart';
import 'indicators_sector_by_level.dart';

class Indicator {
  final IndicatorsSchoolCount schoolCount;
  final IndicatorsEnrolmentByLevel enrolment;
  final IndicatorsEnrolmentByEducationYear enrolmentLastGrade;
  final Indicator previous;
  final IndicatorsSectorByLevel sector;

  const Indicator({
    @required this.schoolCount,
    @required this.enrolment,
    @required this.enrolmentLastGrade,
    @required this.previous,
    @required this.sector,
  });
}