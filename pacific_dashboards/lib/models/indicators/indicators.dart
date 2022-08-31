import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolment_by_level.dart';
import 'package:pacific_dashboards/models/indicators/indicators_enrolments_by_level.dart';
import 'package:pacific_dashboards/models/indicators/indicators_school_counts.dart';

import '../lookups/lookups.dart';
import 'indicators_enrolment_by_education_year.dart';
import 'indicators_enrolments_by_education_year.dart';
import 'indicators_school_count.dart';
import 'indicators_sector_by_level.dart';
import 'indicators_sectors_by_level.dart';

part 'indicators.g.dart';

@JsonSerializable()
class Indicators {
  @JsonKey(name: 'SchoolCounts')
  final IndicatorsSchoolCounts schoolCounts;

  @JsonKey(name: 'ERs')
  final IndicatorsEnrolmentsByLevel enrolments;

  @JsonKey(name: 'LevelERs')
  final IndicatorsEnrolmentsByEducationYear enrolmentsByEducationYear;

  @JsonKey(name: 'Sectors', defaultValue: null)
  final IndicatorsSectorsByLevel sectors;

  const Indicators({
    @required this.schoolCounts,
    @required this.enrolments,
    @required this.enrolmentsByEducationYear,
    @required this.sectors,
  });

  IndicatorsEnrolmentByLevel getEnrolment(String year, String educationCode) {
    IndicatorsEnrolmentByLevel indicatorsEnrolmentByLevel;
    var foundEnrolments = false;
    enrolments.enrolments.forEach((element) {
      if (element.year == year &&
          element.educationLevelCode == educationCode) {
        foundEnrolments = true;
        indicatorsEnrolmentByLevel = element;
      }
    });
    if (!foundEnrolments)
      indicatorsEnrolmentByLevel = new IndicatorsEnrolmentByLevel(
          year: year, educationLevelCode: educationCode);
    return indicatorsEnrolmentByLevel;
  }

  IndicatorsEnrolmentByEducationYear getEnrolmentLastYear(
      String year,
      IndicatorsEnrolmentByLevel indicatorsEnrolmentByLevel) {
    IndicatorsEnrolmentByEducationYear indicatorsEnrolmentYear;
    var foundEducationYear = false;
    enrolmentsByEducationYear.enrolments.forEach((element) {
      if (element.year == year && indicatorsEnrolmentByLevel.isLastYear(
          int.tryParse(element.yearOfEducation))) {
        foundEducationYear = true;
        indicatorsEnrolmentYear = element;
      }
    });
    if (!foundEducationYear)
      indicatorsEnrolmentYear = new IndicatorsEnrolmentByEducationYear(
          year: year);
    return indicatorsEnrolmentYear;
  }

  IndicatorsSchoolCount getSchoolCount(
      String year,
      IndicatorsEnrolmentByLevel indicatorsEnrolmentByLevel,
      Lookups lookups) {

    var schoolTypesOfLevel = lookups.schoolTypeLevels.expand((e) =>
    [
      if (indicatorsEnrolmentByLevel.isSchoolOfLevel(e.yearOfEducation)) e
          .schoolCode
    ]).uniques((it) => it);

    var schoolCount = 0;
    schoolCounts.schoolCounts.forEach((element) {
      if (element.year == year &&
          schoolTypesOfLevel.contains(element.schoolType)) {
        schoolCount += element.count;
      }
    });

    IndicatorsSchoolCount indicatorsSchoolCount = new IndicatorsSchoolCount(
        year: year, count: schoolCount);

    return indicatorsSchoolCount;
  }

  IndicatorsSectorByLevel getSector(
      IndicatorsEnrolmentByLevel enrol) {

    IndicatorsSectorByLevel result = null;
    sectors.sectors.forEach((e) {
      if (enrol.educationLevelCode != null && e.sectorCode != null) {
        print(e.sectorCode + '_' + enrol.educationLevelCode);
        if (e.year == enrol.year && e.sectorCode == enrol.educationLevelCode) {
          print(e.toJson());
          result = e;
        }
      }
    });
    return result == null
        ? IndicatorsSectorByLevel(year: enrol.year, sectorCode: enrol.educationLevelCode)
        : result;
  }

  factory Indicators.fromJson(Map<String, dynamic> json) => _$IndicatorsFromJson(json);

  Map<String, dynamic> toJson() => _$IndicatorsToJson(this);
}