import 'dart:ui';
import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/indicators/indicator.dart';
import 'package:pacific_dashboards/pages/indicators/components/indicators_filters.dart';
import 'package:pacific_dashboards/pages/indicators/indicators_filters_page.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import '../../individual_school/components/dashboards/components/enroll/components/gender_history_component.dart';
import '../../individual_school/components/dashboards/components/enroll/enroll_data.dart';

class IndicatorsChart extends StatelessWidget {
  final List<Indicator> _indicators;

  const IndicatorsChart({
    Key key,
    @required List<Indicator> indicators,
  })  : assert(indicators != null),
        _indicators = indicators,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final byPopulation = _indicators.where((e) => e.enrolment.population != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.population,
              female: e.enrolment.populationFemale,
              male: e.enrolment.populationMale,
            ))
        .toList();
    final byEnrol = _indicators.where((e) => e.enrolment.enrol != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.enrol,
              female: e.enrolment.enrolFemale,
              male: e.enrolment.enrolMale,
            ))
        .toList();
    final byNetEnrol = _indicators.where((e) => e.enrolment.enrolOfficialAge != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.enrolOfficialAge,
              female: e.enrolment.enrolOfficialAgeFemale,
              male: e.enrolment.enrolOfficialAgeMale,
            ))
        .toList();
    final byNER = _indicators.where((e) => e.enrolment.netEnrolmentRatio != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.netEnrolmentRatio,
              female: e.enrolment.netEnrolmentRatioFemale,
              male: e.enrolment.netEnrolmentRatioMale,
            ))
        .toList();
    final byGER = _indicators.where((e) => e.enrolment.grossEnrolmentRatio != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.grossEnrolmentRatio,
              female: e.enrolment.grossEnrolmentRatioFemale,
              male: e.enrolment.grossEnrolmentRatioMale,
            ))
        .toList();

    //TODO correct teachers numbers
    final byTeachers = _indicators.where((e) => e.enrolment.population != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.population,
              female: e.enrolment.populationFemale,
              male: e.enrolment.populationMale,
            ))
        .toList();
    final byTeachersC = _indicators.where((e) => e.enrolment.population != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.population,
              female: e.enrolment.populationFemale,
              male: e.enrolment.populationMale,
            ))
        .toList();
    final byTeachersQ = _indicators.where((e) => e.enrolment.population != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.population,
              female: e.enrolment.populationFemale,
              male: e.enrolment.populationMale,
            ))
        .toList();

    final byRepeaters = _indicators.where((e) => e.enrolment.repeaters != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.repeaters,
              female: e.enrolment.repeatersFemale,
              male: e.enrolment.repeatersMale,
            ))
        .toList();
    final byRepRate = _indicators
        .mapIndexed((i, e) => i > 0 && e.enrolment.repeaters != 0
        && _indicators[i-1].enrolment.enrol != 0
        ? EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.repeaters / _indicators[i-1].enrolment.enrol,
              female: e.enrolment.repeatersFemale / _indicators[i-1].enrolment.enrolFemale,
              male: e.enrolment.repeatersMale / _indicators[i-1].enrolment.enrolMale,
            )
        : null)
        .toList().where((e) => e != null).toList();

    final byIntake = _indicators.where((e) => e.enrolment.intake != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.intake,
              female: e.enrolment.intakeFemale,
              male: e.enrolment.intakeMale,
            ))
        .toList();
    final byGir = _indicators.where((e) => e.enrolment.grossIntakeRatio != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.grossIntakeRatio,
              female: e.enrolment.grossIntakeRatioFemale,
              male: e.enrolment.grossIntakeRatioMale,
            ))
        .toList();
    final byNetIntake = _indicators.where((e) => e.enrolment.netIntake != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.netIntake,
              female: e.enrolment.netIntakeFemale,
              male: e.enrolment.netIntakeMale,
            ))
        .toList();
    final byNIR = _indicators.where((e) => e.enrolment.netIntakeRatio != 0)
        .map((e) => EnrollDataByYear(
              year: int.parse(e.enrolment.year),
              total: e.enrolment.netIntakeRatio,
              female: e.enrolment.netIntakeRatioFemale,
              male: e.enrolment.netIntakeRatioMale,
            ))
        .toList();

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'indicatorsDemographic'.localized(context),
              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 18),
            ),
            MiniTabLayout(
                tabs: ['population', 'enrolment', 'netEnrolment', 'netEnrolmentRatio', 'grossEnrolmentRatio'],
                padding: 0.0,
                tabNameBuilder: (tab) {
                  switch (tab) {
                    case 'population':
                      return 'population'.localized(context);
                      break;
                    case 'enrolment':
                      return 'enrolment'.localized(context);
                      break;
                    case 'netEnrolment':
                      return 'netEnrolment'.localized(context);
                      break;
                    case 'netEnrolmentRatio':
                      return 'netEnrolmentRatio'.localized(context);
                      break;
                    case 'grossEnrolmentRatio':
                      return 'grossEnrolmentRatio'.localized(context);
                      break;
                  }
                  throw FallThroughError();
                },
                builder: (ctx, tab) {
                  switch (tab) {
                    case 'population':
                      return _chartWithNameAndData('population'.localized(context), byPopulation);
                      break;
                    case 'enrolment':
                      return _chartWithNameAndData('enrolment'.localized(context), byEnrol);
                      break;
                    case 'netEnrolment':
                      return _chartWithNameAndData('netEnrolment'.localized(context), byNetEnrol);
                      break;
                    case 'netEnrolmentRatio':
                      return _chartWithNameAndData('netEnrolmentRatio'.localized(context), byNER);
                      break;
                    case 'grossEnrolmentRatio':
                      return _chartWithNameAndData('grossEnrolmentRatio'.localized(context), byGER);
                      break;
                  }
                  throw FallThroughError();
                }),
            SizedBox(height: 24),
            Text(
              'indicatorsQuality'.localized(context),
              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 18),
            ),
            MiniTabLayout(
                tabs: ['teachers', 'certified', 'qualified'],
                padding: 0.0,
                tabNameBuilder: (tab) {
                  switch (tab) {
                    case 'teachers':
                      return 'teachers'.localized(context);
                      break;
                    case 'certified':
                      return 'certified'.localized(context);
                      break;
                    default:
                      return 'qualified'.localized(context);
                      break;
                  };
                },
                builder: (ctx, tab) {
                  switch (tab) {
                    case 'teachers':
                      return _chartWithNameAndData('teachers'.localized(context), byTeachers);
                      break;
                    case 'certified':
                      return _chartWithNameAndData('certified'.localized(context), byTeachersC);
                      break;
                    default:
                      return _chartWithNameAndData('qualified'.localized(context), byTeachersQ);
                      break;
                  }
                }),
            SizedBox(height: 24),
            Text(
              'indicatorsProcess'.localized(context),
              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 18),
            ),
            MiniTabLayout(
                tabs: ['repeaters', 'repetitionRate'],
                padding: 0.0,
                tabNameBuilder: (tab) {
                  switch (tab) {
                    case 'repeaters':
                      return 'repeaters'.localized(context);
                      break;
                    case 'repetitionRate':
                      return 'repetitionRate'.localized(context);
                      break;
                  }
                  throw FallThroughError();
                },
                builder: (ctx, tab) {
                  switch (tab) {
                    case 'repeaters':
                      return _chartWithNameAndData('repeaters'.localized(context), byRepeaters);
                      break;
                    case 'repetitionRate':
                      return _chartWithNameAndData('repetitionRate'.localized(context), byRepRate);
                      break;
                  }
                  throw FallThroughError();
                }),
            SizedBox(height: 24),
            Text(
              'indicatorsOutcome'.localized(context),
              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 18),
            ),
            MiniTabLayout(
                tabs: ['intake', 'grossIntakeRatio', 'netIntake', 'netIntakeRatio'],
                padding: 0.0,
                tabNameBuilder: (tab) {
                  switch (tab) {
                    case 'intake':
                      return 'intake'.localized(context);
                      break;
                    case 'grossIntakeRatio':
                      return 'grossIntakeRatio'.localized(context);
                      break;
                    case 'netIntake':
                      return 'netIntake'.localized(context);
                      break;
                    case 'netIntakeRatio':
                      return 'netIntakeRatio'.localized(context);
                      break;
                  }
                  throw FallThroughError();
                },
                builder: (ctx, tab) {
                  switch (tab) {
                    case 'intake':
                      return _chartWithNameAndData('intake'.localized(context), byIntake);
                      break;
                    case 'grossIntakeRatio':
                      return _chartWithNameAndData('grossIntakeRatio'.localized(context), byGir);
                      break;
                    case 'netIntake':
                      return _chartWithNameAndData('netIntake'.localized(context), byNetIntake);
                      break;
                    case 'netIntakeRatio':
                      return _chartWithNameAndData('netIntakeRatio'.localized(context), byNIR);
                      break;
                  }
                  throw FallThroughError();
                }),
          ],
        ));
  }

  Widget _chartWithNameAndData(String text, List<EnrollDataByYear> data) {
    return Column(
        children: [
          UnstackedChart(
            data: data,
            includePoints: true,
          ),
          SizedBox(height: 16),
          MultiTableWidget(
            columnNames: [
              'Year',
              'Total',
              'Male',
              'Female',
            ],
            columnFlex: [50, 30, 30, 30],
            data: Map.fromIterable(data, key: (e) => e.year.toString(), value: (e) => e),
            domainValueBuilder: (index, data) {
              num result;
              String imagePath;
              switch (index) {
                case 0:
                  return CellData(
                      value: data.domain);
                  break;
                case 1:
                  result = data.measure.total;
                  break;
                case 2:
                  result = data.measure.male;
                  break;
                case 3:
                  result = data.measure.female;
                  break;
              }

              if (result != null) {
                return CellData(
                    value: result is int ? result.toString() : (result * 100)
                        .toStringAsFixed(2) + "%",
                    svgImagePath: imagePath,
                    imageX: 26,
                    imageY: 16);
              } else {
                return CellData(value: "");
              }
            },
          )
        ]
    );
    // ];
  }

  num _Percent(num first, num second) {
    return first != null && second != null ? first / second : null;
  }
}
