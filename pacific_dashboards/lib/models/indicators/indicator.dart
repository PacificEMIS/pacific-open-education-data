import 'package:flutter/foundation.dart';
import 'indicators_enrolment_by_level.dart';
import 'indicators_school_count.dart';

class Indicator {
  final IndicatorsSchoolCount schoolCount;
  final IndicatorsEnrolmentByLevel enrolment;

  const Indicator({
    @required this.schoolCount,
    @required this.enrolment,
  });
}