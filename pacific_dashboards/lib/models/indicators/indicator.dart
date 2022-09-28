import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_education_year.dart';
import 'package:pacific_dashboards/models/indicators/indicators_survival_by_level.dart';
import 'indicators_enrolment_by_level.dart';
import 'indicators_school_count.dart';
import 'indicators_sector_by_level.dart';
import 'indicators_teacher_by_level.dart';

class Indicator {
  final IndicatorsSchoolCount schoolCount;
  final IndicatorsEnrolmentByLevel enrolment;
  final IndicatorsEnrolmentByEducationYear enrolmentLastGrade;
  final List<IndicatorsEnrolmentByEducationYear> allGradesCurrentYear;
  final Indicator previous;
  //final IndicatorsSectorByLevel sector;
  final IndicatorsTeacherByLevel teacherELevel;
  final IndicatorsSurvivalByLevel survival;

  String get survivalFromFirstYearString {
    return "Survival Rate (to Year ${enrolment.lastYear})";
  }

  double get survivalFromFirstYear {
    return previous?.survival?.survivalRate ?? 0;
  }

  double get survivalFromFirstYearMale {
    return previous?.survival?.survivalRateM ?? 0;
  }

  double get survivalFromFirstYearFemale {
    return previous?.survival?.survivalRateF ?? 0;
  }

  double _survivalFromFirstYear(Indicator indicator, IndicatorsEnrolmentByEducationYear current, int gender) {
    if (current.studyYear == 1) {
      return 1;
    } else {
      if (indicator.previous != null) {
        var previousGrade = indicator.previous.allGradesCurrentYear.where((e) =>
        e.studyYear == current.studyYear - 1);
        if (previousGrade.isEmpty) {
          return 1;//0; survival from any available year if no data from study year 1
        } else {
          var grade = previousGrade.first;
          print("${grade.year}_${grade.yearOfEducation}_${current.enrol}_${grade.enrol}_${current.enrol/grade.enrol}");
          var ratio = 0.0;
          switch (gender) {
            case 0:
              ratio = current.enrol / grade.enrol;
              break;
            case 1:
              ratio = current.enrolMale / grade.enrolMale;
              break;
            case 2:
              ratio = current.enrolFemale / grade.enrolFemale;
              break;
          }
          return _survivalFromFirstYear(indicator.previous, grade, gender) * ratio;
        }
      }
      return 0;
    }
  }

  const Indicator({
    @required this.schoolCount,
    @required this.enrolment,
    @required this.enrolmentLastGrade,
    @required this.allGradesCurrentYear,
    @required this.previous,
    //@required this.sector,
    @required this.teacherELevel,
    @required this.survival,
  });
}