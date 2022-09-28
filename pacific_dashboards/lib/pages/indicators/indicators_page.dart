import 'dart:ui';

import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/indicators/indicator.dart';
import 'package:pacific_dashboards/pages/indicators/components/indicators_charts.dart';
import 'package:pacific_dashboards/pages/indicators/components/indicators_filters.dart';
import 'package:pacific_dashboards/pages/indicators/indicators_filters_page.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import 'indicators_filter_data.dart';
import 'indicators_view_model.dart';

enum _MainTab { grid, charts }

enum _GenderTab { all, female, male, femalePercent }

class IndicatorsPage extends MvvmStatefulWidget {
  static const String kRoute = "/Indicators";

  IndicatorsPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) => ViewModelFactory.instance.createIndicatorsViewModel(ctx),
        );

  @override
  State<StatefulWidget> createState() {
    return IndicatorsPageState();
  }
}

class IndicatorsPageState extends MvvmState<IndicatorsViewModel, IndicatorsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        title: Text(
          'indicatorsDashboardsTitle'.localized(context),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          StreamBuilder<IndicatorsFilterData>(
            stream: viewModel.filtersStream,
            builder: (ctx, snapshot) {
              return Visibility(
                visible: snapshot.hasData,
                child: IconButton(
                  icon: SvgPicture.asset('images/filter.svg'),
                  onPressed: () {
                    _openFilters();
                  },
                ),
              );
            },
          )
        ],
      ),
      body: LoadingStack(
        errorStateStream: viewModel.errorMessagesStream,
        loadingStateStream: viewModel.activityIndicatorStream,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<Pair<Indicator, Indicator>>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    //return Container();
                    return new Column(children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          viewModel != null ? viewModel.pageName : "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      _PopulatedContent(indicators: snapshot.data, viewModel: viewModel),
                    ]);
                  }
                },
              ),
              Container(height: 150)
            ],
          ),
        ),
      ),
      bottomSheet: IndicatorsFiltersWidget(
        bottomInset: bottomInset,
        viewModel: viewModel,
      ),
    );
  }

  void _openFilters() {
    Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (context) {
        return IndicatorsFiltersPage(
            filtersData: viewModel.filterData,
            canSelectYears: viewModel.years,
            regionName: viewModel.regionName,
            regions: viewModel.regions);
      }),
    ).then((years) => _applyFilters(context, new Pair(years[0], years[1]), years[2]));
  }

  void _applyFilters(BuildContext context, Pair<String, String> years, String regionName) {
    if (years != null) viewModel.onYearFiltersChanged(years);
    if (regionName != null) {
      viewModel.regionName = regionName;
      viewModel.loadData();
    }
  }
}

class _PopulatedContent extends StatelessWidget {
  final Pair<Indicator, Indicator> _indicators;
  final IndicatorsViewModel _viewModel;

  const _PopulatedContent({
    Key key,
    @required Pair<Indicator, Indicator> indicators,
    @required IndicatorsViewModel viewModel,
  })  : assert(indicators != null),
        _indicators = indicators,
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var shouldShowSchoolCount = _viewModel.shouldShowSchoolCount;
    return MiniTabLayout(
        padding: 0,
        tabs: _MainTab.values,
        tabNameBuilder: (mainTab) {
          switch (mainTab) {
            case _MainTab.grid:
              return 'indicatorsDateGrid'.localized(context);
            case _MainTab.charts:
              return 'indicatorsHistoricalCharts'.localized(context);
          }
          throw FallThroughError();
        },
        builder: (ctx, tab) {
          switch (tab) {
            case _MainTab.grid:
              return MiniTabLayout(
                tabs: _GenderTab.values,
                tabNameBuilder: (tab) {
                  switch (tab) {
                    case _GenderTab.all:
                      return 'labelTotal'.localized(context);
                    case _GenderTab.male:
                      return 'labelMale'.localized(context);
                    case _GenderTab.female:
                      return 'labelFemale'.localized(context);
                    case _GenderTab.femalePercent:
                      return 'labelFemalePercent'.localized(context);
                  }
                  throw FallThroughError();
                },
                builder: (ctx, tab) {
                  switch (tab) {
                    case _GenderTab.all:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, TypedPair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': TypedPair(
                              _indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': TypedPair(
                              _indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          if (shouldShowSchoolCount)
                            'indicatorsNumberOfSchools': TypedPair(
                                _indicators.first.schoolCount.count,
                                _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': TypedPair(_indicators.first.enrolment.population,
                              _indicators.second.enrolment.population),
                          'indicatorsTotalEnrolment': TypedPair(_indicators.first.enrolment.enrol,
                              _indicators.second.enrolment.enrol),
                          'indicatorsOfficialAgeEnrolment': TypedPair(
                              _indicators.first.enrolment.enrolOfficialAge,
                              _indicators.second.enrolment.enrolOfficialAge),
                          'indicatorsGrossEnrolment': TypedPair(
                              _indicators.first.enrolment.grossEnrolmentRatio,
                              _indicators.second.enrolment.grossEnrolmentRatio),
                          'indicatorsNetEnrolment': TypedPair(
                              _indicators.first.enrolment.netEnrolmentRatio,
                              _indicators.second.enrolment.netEnrolmentRatio),
                          'indicatorsQuality': null,
                          'numberOfTeachers': TypedPair(_indicators.first.teacherELevel.teachers,
                              _indicators.second.teacherELevel.teachers),
                          'certified': TypedPair(_indicators.first.teacherELevel.certified,
                              _indicators.second.teacherELevel.certified),
                          'certifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.certifiedPercent,
                              _indicators.second.teacherELevel.certifiedPercent),
                          'qualified': TypedPair(_indicators.first.teacherELevel.qualified,
                              _indicators.second.teacherELevel.qualified),
                          'qualifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.qualifiedPercent,
                              _indicators.second.teacherELevel.qualifiedPercent),
                          'pupilTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatio,
                              _indicators.second.teacherELevel.pupilTeacherRatio,
                              isRatio: true),
                          'pupilCertifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioCertified,
                              _indicators.second.teacherELevel.pupilTeacherRatioCertified,
                              isRatio: true),
                          'pupilQualifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioQualified,
                              _indicators.second.teacherELevel.pupilTeacherRatioQualified,
                              isRatio: true),
                          'indicatorsProcess': null,
                          'repeatersNumber': TypedPair(_indicators.first.enrolment.repeaters,
                              _indicators.second.enrolment.repeaters),
                          'repetitionRate': TypedPair(
                              _indicators.first.enrolment.repeaters == 0 ||
                                      _indicators.first.previous == null ||
                                      _indicators.first.previous.enrolment.enrol == 0
                                  ? null
                                  : _indicators.first.enrolment.repeaters /
                                      _indicators.first.previous.enrolment.enrol,
                              _indicators.second.enrolment.repeaters == 0 ||
                                      _indicators.second.previous == null ||
                                      _indicators.second.previous.enrolment.enrol == 0
                                  ? null
                                  : _indicators.second.enrolment.repeaters /
                                      _indicators.second.previous.enrolment.enrol),
                          'indicatorsOutcome': null,
                          if (_indicators.first.enrolment.lastYear != '0')
                            'survivalRate': TypedPair(
                              _indicators.first.survivalFromFirstYear,
                              _indicators.second.survivalFromFirstYear,
                              nameReplace: _indicators.first.survivalFromFirstYearString,
                            ),
                          'intake': TypedPair(_indicators.first.enrolment.intake,
                              _indicators.second.enrolment.intake),
                          'grossIntakeRatio': TypedPair(
                              _indicators.first.enrolment.grossIntakeRatio,
                              _indicators.second.enrolment.grossIntakeRatio),
                          'netIntake': TypedPair(_indicators.first.enrolment.netIntake,
                              _indicators.second.enrolment.netIntake),
                          'netIntakeRatio': TypedPair(_indicators.first.enrolment.netIntakeRatio,
                              _indicators.second.enrolment.netIntakeRatio),
                          if (_indicators.first.enrolment.lastYear != '0')
                            'grossIRLG': TypedPair(
                                _indicators.first.enrolmentLastGrade.grossIntakeRatio,
                                _indicators.second.enrolmentLastGrade.grossIntakeRatio),
                        },
                      );
                    case _GenderTab.male:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, TypedPair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': TypedPair(
                              _indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': TypedPair(
                              _indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          if (shouldShowSchoolCount)
                            'indicatorsNumberOfSchools': TypedPair(
                                _indicators.first.schoolCount.count,
                                _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': TypedPair(
                              _indicators.first.enrolment.populationMale,
                              _indicators.second.enrolment.populationMale),
                          'indicatorsTotalEnrolment': TypedPair(
                              _indicators.first.enrolment.enrolMale,
                              _indicators.second.enrolment.enrolMale),
                          'indicatorsOfficialAgeEnrolment': TypedPair(
                              _indicators.first.enrolment.enrolOfficialAgeMale,
                              _indicators.second.enrolment.enrolOfficialAgeMale),
                          'indicatorsGrossEnrolment': TypedPair(
                              _indicators.first.enrolment.grossEnrolmentRatioMale,
                              _indicators.second.enrolment.grossEnrolmentRatioMale),
                          'indicatorsNetEnrolment': TypedPair(
                              _indicators.first.enrolment.netEnrolmentRatioMale,
                              _indicators.second.enrolment.netEnrolmentRatioMale),
                          'indicatorsQuality': null,
                          'numberOfTeachers': TypedPair(
                              _indicators.first.teacherELevel.teachersMale,
                              _indicators.second.teacherELevel.teachersMale),
                          'certified': TypedPair(_indicators.first.teacherELevel.certifiedMale,
                              _indicators.second.teacherELevel.certifiedMale),
                          'certifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.certifiedPercentMale,
                              _indicators.second.teacherELevel.certifiedPercentMale),
                          'qualified': TypedPair(_indicators.first.teacherELevel.qualifiedMale,
                              _indicators.second.teacherELevel.qualifiedMale),
                          'qualifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.qualifiedPercentMale,
                              _indicators.second.teacherELevel.qualifiedPercentMale),
                          'pupilTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatio,
                              _indicators.second.teacherELevel.pupilTeacherRatio,
                              isRatio: true),
                          'pupilCertifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioCertified,
                              _indicators.second.teacherELevel.pupilTeacherRatioCertified,
                              isRatio: true),
                          'pupilQualifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioQualified,
                              _indicators.second.teacherELevel.pupilTeacherRatioQualified,
                              isRatio: true),
                          'indicatorsProcess': null,
                          'repeatersNumber': TypedPair(_indicators.first.enrolment.repeatersMale,
                              _indicators.second.enrolment.repeatersMale),
                          'repetitionRate': TypedPair(
                              _indicators.first.enrolment.repeatersMale == 0 ||
                                      _indicators.first.previous == null ||
                                      _indicators.first.previous.enrolment.enrolMale == 0
                                  ? null
                                  : _indicators.first.enrolment.repeatersMale /
                                      _indicators.first.previous.enrolment.enrolMale,
                              _indicators.second.enrolment.repeatersMale == 0 ||
                                      _indicators.second.previous == null ||
                                      _indicators.second.previous.enrolment.enrolMale == 0
                                  ? null
                                  : _indicators.second.enrolment.repeatersMale /
                                      _indicators.second.previous.enrolment.enrolMale),
                          'indicatorsOutcome': null,
                          if (_indicators.first.enrolment.lastYear != '0')
                            'survivalRate': TypedPair(
                              _indicators.first.survivalFromFirstYearMale,
                              _indicators.second.survivalFromFirstYearMale,
                              nameReplace: _indicators.first.survivalFromFirstYearString,
                            ),
                          'intake': TypedPair(_indicators.first.enrolment.intakeMale,
                              _indicators.second.enrolment.intakeMale),
                          'grossIntakeRatio': TypedPair(
                              _indicators.first.enrolment.grossIntakeRatioMale,
                              _indicators.second.enrolment.grossIntakeRatioMale),
                          'netIntake': TypedPair(_indicators.first.enrolment.netIntakeMale,
                              _indicators.second.enrolment.netIntakeMale),
                          'netIntakeRatio': TypedPair(
                              _indicators.first.enrolment.netIntakeRatioMale,
                              _indicators.second.enrolment.netIntakeRatioMale),
                          if (_indicators.first.enrolment.lastYear != '0')
                            'grossIRLG': TypedPair(
                                _indicators.first.enrolmentLastGrade.grossIntakeRatioMale,
                                _indicators.second.enrolmentLastGrade.grossIntakeRatioMale),
                        },
                      );
                    case _GenderTab.female:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, TypedPair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': TypedPair(
                              _indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': TypedPair(
                              _indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          if (shouldShowSchoolCount)
                            'indicatorsNumberOfSchools': TypedPair(
                                _indicators.first.schoolCount.count,
                                _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': TypedPair(
                              _indicators.first.enrolment.populationFemale,
                              _indicators.second.enrolment.populationFemale),
                          'indicatorsTotalEnrolment': TypedPair(
                              _indicators.first.enrolment.enrolFemale,
                              _indicators.second.enrolment.enrolFemale),
                          'indicatorsOfficialAgeEnrolment': TypedPair(
                              _indicators.first.enrolment.enrolOfficialAgeFemale,
                              _indicators.second.enrolment.enrolOfficialAgeFemale),
                          'indicatorsGrossEnrolment': TypedPair(
                              _indicators.first.enrolment.grossEnrolmentRatioFemale,
                              _indicators.second.enrolment.grossEnrolmentRatioFemale),
                          'indicatorsNetEnrolment': TypedPair(
                              _indicators.first.enrolment.netEnrolmentRatioFemale,
                              _indicators.second.enrolment.netEnrolmentRatioFemale),
                          'indicatorsQuality': null,
                          'numberOfTeachers': TypedPair(
                              _indicators.first.teacherELevel.teachersFemale,
                              _indicators.second.teacherELevel.teachersFemale),
                          'certified': TypedPair(_indicators.first.teacherELevel.certifiedFemale,
                              _indicators.second.teacherELevel.certifiedFemale),
                          'certifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.certifiedPercentFemale,
                              _indicators.second.teacherELevel.certifiedPercentFemale),
                          'qualified': TypedPair(_indicators.first.teacherELevel.qualifiedFemale,
                              _indicators.second.teacherELevel.qualifiedFemale),
                          'qualifiedPercentage': TypedPair(
                              _indicators.first.teacherELevel.qualifiedPercentFemale,
                              _indicators.second.teacherELevel.qualifiedPercentFemale),
                          'pupilTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatio,
                              _indicators.second.teacherELevel.pupilTeacherRatio,
                              isRatio: true),
                          'pupilCertifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioCertified,
                              _indicators.second.teacherELevel.pupilTeacherRatioCertified,
                              isRatio: true),
                          'pupilQualifiedTeachersRation': TypedPair(
                              _indicators.first.teacherELevel.pupilTeacherRatioQualified,
                              _indicators.second.teacherELevel.pupilTeacherRatioQualified,
                              isRatio: true),
                          'indicatorsProcess': null,
                          'repeatersNumber': TypedPair(_indicators.first.enrolment.repeatersFemale,
                              _indicators.second.enrolment.repeatersFemale),
                          'repetitionRate': TypedPair(
                              _indicators.first.enrolment.repeatersFemale == 0 ||
                                      _indicators.first.previous == null ||
                                      _indicators.first.previous.enrolment.enrolFemale == 0
                                  ? null
                                  : _indicators.first.enrolment.repeatersFemale /
                                      _indicators.first.previous.enrolment.enrolFemale,
                              _indicators.second.enrolment.repeatersFemale == 0 ||
                                      _indicators.second.previous == null ||
                                      _indicators.second.previous.enrolment.enrolFemale == 0
                                  ? null
                                  : _indicators.second.enrolment.repeatersFemale /
                                      _indicators.second.previous.enrolment.enrolFemale),
                          'indicatorsOutcome': null,
                          if (_indicators.first.enrolment.lastYear != '0')
                            'survivalRate': TypedPair(
                              _indicators.first.survivalFromFirstYearFemale,
                              _indicators.second.survivalFromFirstYearFemale,
                              nameReplace: _indicators.first.survivalFromFirstYearString,
                            ),
                          'intake': TypedPair(_indicators.first.enrolment.intakeFemale,
                              _indicators.second.enrolment.intakeFemale),
                          'grossIntakeRatio': TypedPair(
                              _indicators.first.enrolment.grossIntakeRatioFemale,
                              _indicators.second.enrolment.grossIntakeRatioFemale),
                          'netIntake': TypedPair(_indicators.first.enrolment.netIntakeFemale,
                              _indicators.second.enrolment.netIntakeFemale),
                          'netIntakeRatio': TypedPair(
                              _indicators.first.enrolment.netIntakeRatioFemale,
                              _indicators.second.enrolment.netIntakeRatioFemale),
                          if (_indicators.first.enrolment.lastYear != '0')
                            'grossIRLG': TypedPair(
                                _indicators.first.enrolmentLastGrade.grossIntakeRatioFemale,
                                _indicators.second.enrolmentLastGrade.grossIntakeRatioFemale),
                        },
                      );
                    case _GenderTab.femalePercent:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, TypedPair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': TypedPair(
                              _indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': TypedPair(
                              _indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          if (shouldShowSchoolCount)
                            'indicatorsNumberOfSchools': TypedPair(
                                _indicators.first.schoolCount.count,
                                _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': TypedPair(
                              _Percent(_indicators.first.enrolment.populationFemale,
                                  _indicators.first.enrolment.population),
                              _Percent(_indicators.second.enrolment.populationFemale,
                                  _indicators.second.enrolment.population)),
                          'indicatorsTotalEnrolment': TypedPair(
                              _Percent(_indicators.first.enrolment.enrolFemale,
                                  _indicators.first.enrolment.enrol),
                              _Percent(_indicators.second.enrolment.enrolFemale,
                                  _indicators.second.enrolment.enrol)),
                          'indicatorsOfficialAgeEnrolment': TypedPair(
                              _Percent(_indicators.first.enrolment.enrolOfficialAgeFemale,
                                  _indicators.first.enrolment.enrolOfficialAge),
                              _Percent(_indicators.second.enrolment.enrolOfficialAgeFemale,
                                  _indicators.second.enrolment.enrolOfficialAge)),
                          'indicatorsGrossEnrolment': TypedPair(
                              _Percent(_indicators.first.enrolment.grossEnrolmentRatioFemale,
                                  _indicators.first.enrolment.grossEnrolmentRatioMale),
                              _Percent(_indicators.second.enrolment.grossEnrolmentRatioFemale,
                                  _indicators.second.enrolment.grossEnrolmentRatioMale),
                              isRatio: true),
                          'indicatorsNetEnrolment': TypedPair(
                              _Percent(_indicators.first.enrolment.netEnrolmentRatioFemale,
                                  _indicators.first.enrolment.netEnrolmentRatioMale),
                              _Percent(_indicators.second.enrolment.netEnrolmentRatioFemale,
                                  _indicators.second.enrolment.netEnrolmentRatioMale),
                              isRatio: true),
                          'indicatorsQuality': null,
                          'numberOfTeachers': TypedPair(
                              _Percent(_indicators.first.teacherELevel.teachersFemale,
                                  _indicators.first.teacherELevel.teachers),
                              _Percent(_indicators.second.teacherELevel.teachersFemale,
                                  _indicators.second.teacherELevel.teachers)),
                          'certified': TypedPair(
                              _Percent(_indicators.first.teacherELevel.certifiedFemale,
                                  _indicators.first.teacherELevel.certified),
                              _Percent(_indicators.second.teacherELevel.certifiedFemale,
                                  _indicators.second.teacherELevel.certified)),
                          'certifiedPercentage': TypedPair(
                              _Percent(_indicators.first.teacherELevel.certifiedPercentFemale,
                                  _indicators.first.teacherELevel.certifiedPercentMale),
                              _Percent(_indicators.second.teacherELevel.certifiedPercentFemale,
                                  _indicators.second.teacherELevel.certifiedPercentMale),
                              isRatio: true),
                          'qualified': TypedPair(
                              _Percent(_indicators.first.teacherELevel.qualifiedFemale,
                                  _indicators.first.teacherELevel.qualified),
                              _Percent(_indicators.second.teacherELevel.qualifiedFemale,
                                  _indicators.second.teacherELevel.qualified)),
                          'qualifiedPercentage': TypedPair(
                              _Percent(_indicators.first.teacherELevel.qualifiedPercentFemale,
                                  _indicators.first.teacherELevel.qualifiedPercentMale),
                              _Percent(_indicators.second.teacherELevel.qualifiedPercentFemale,
                                  _indicators.second.teacherELevel.qualifiedPercentMale),
                              isRatio: true),
                          'indicatorsProcess': null,
                          'repeatersNumber': TypedPair(
                              _Percent(_indicators.first.enrolment.repeatersFemale,
                                  _indicators.first.enrolment.repeaters),
                              _Percent(_indicators.second.enrolment.repeatersFemale,
                                  _indicators.second.enrolment.repeaters)),
                          'repetitionRate': TypedPair(
                              _indicators.first.enrolment.repeatersFemale == 0 ||
                                      _indicators.first.enrolment.repeatersMale == 0 ||
                                      _indicators.first.previous == null ||
                                      _indicators.first.previous.enrolment.enrolFemale == 0 ||
                                      _indicators.first.previous.enrolment.enrolMale == 0
                                  ? null
                                  : _Percent(
                                      _indicators.first.enrolment.repeatersFemale /
                                          _indicators.first.previous.enrolment.enrolFemale,
                                      _indicators.first.enrolment.repeatersMale /
                                          _indicators.first.previous.enrolment.enrolMale),
                              _indicators.second.enrolment.repeatersFemale == 0 ||
                                      _indicators.second.enrolment.repeatersMale == 0 ||
                                      _indicators.second.previous == null ||
                                      _indicators.second.previous.enrolment.enrolFemale == 0 ||
                                      _indicators.second.previous.enrolment.enrolMale == 0
                                  ? null
                                  : _Percent(
                                      _indicators.second.enrolment.repeatersFemale /
                                          _indicators.second.previous.enrolment.enrolFemale,
                                      _indicators.second.enrolment.repeatersMale /
                                          _indicators.second.previous.enrolment.enrolMale),
                              isRatio: true),
                          'indicatorsOutcome': null,
                          if (_indicators.first.enrolment.lastYear != '0')
                            'survivalRate': TypedPair(
                                _Percent(_indicators.first.survivalFromFirstYearFemale,
                                    _indicators.first.survivalFromFirstYearMale),
                                _Percent(_indicators.second.survivalFromFirstYearFemale,
                                    _indicators.second.survivalFromFirstYearMale),
                                nameReplace: _indicators.first.survivalFromFirstYearString,
                                isRatio: true),
                          'intake': TypedPair(
                              _Percent(_indicators.first.enrolment.intakeFemale,
                                  _indicators.first.enrolment.intake),
                              _Percent(_indicators.second.enrolment.intakeFemale,
                                  _indicators.second.enrolment.intake)),
                          'grossIntakeRatio': TypedPair(
                              _Percent(_indicators.first.enrolment.grossIntakeRatioFemale,
                                  _indicators.first.enrolment.grossIntakeRatioMale),
                              _Percent(_indicators.second.enrolment.grossIntakeRatioFemale,
                                  _indicators.second.enrolment.grossIntakeRatioMale),
                              isRatio: true),
                          'netIntake': TypedPair(
                              _Percent(_indicators.first.enrolment.netIntakeFemale,
                                  _indicators.first.enrolment.netIntake),
                              _Percent(_indicators.second.enrolment.netIntakeFemale,
                                  _indicators.second.enrolment.netIntake)),
                          'netIntakeRatio': TypedPair(
                              _Percent(_indicators.first.enrolment.netIntakeRatioFemale,
                                  _indicators.first.enrolment.netIntakeRatioMale),
                              _Percent(_indicators.second.enrolment.netIntakeRatioFemale,
                                  _indicators.second.enrolment.netIntakeRatioMale),
                              isRatio: true),
                          if (_indicators.first.enrolment.lastYear != '0')
                            'grossIRLG': TypedPair(
                                _Percent(
                                    _indicators.first.enrolmentLastGrade.grossIntakeRatioFemale,
                                    _indicators.first.enrolmentLastGrade.grossIntakeRatioMale),
                                _Percent(
                                    _indicators.second.enrolmentLastGrade.grossIntakeRatioFemale,
                                    _indicators.second.enrolmentLastGrade.grossIntakeRatioMale),
                                isRatio: true),
                        },
                      );
                  }
                  throw FallThroughError();
                },
              );
            case _MainTab.charts:
              {
                return StreamBuilder<List<Indicator>>(
                    stream: _viewModel.allDataStream,
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return IndicatorsChart(indicators: snapshot.data);
                      }
                    });
              }
          }
          throw FallThroughError();
          ;
        });
  }

  num _Percent(num first, num second) {
    return first != null && second != null ? first / second : null;
  }
}

class _IndicatorsTable extends StatelessWidget {
  const _IndicatorsTable(
      {Key key,
      @required Pair<Indicator, Indicator> indicators,
      @required Map<String, TypedPair<num, num>> data})
      : _indicators = indicators,
        _data = data,
        super(key: key);

  final Pair<Indicator, Indicator> _indicators;
  final Map<String, TypedPair<num, num>> _data;

  @override
  Widget build(BuildContext context) {
    return MultiTableWidget(
      columnNames: [
        '',
        _indicators.first.enrolment.year,
        _indicators.second.enrolment.year,
        'indicatorsDifference'.localized(context)
      ],
      columnFlex: [55, 30, 30, 45],
      data: _data,
      domainValueBuilder: (index, data) {
        num result;
        String imagePath;
        switch (index) {
          case 0:
            var nameReplace = data.measure?.nameReplace ?? "";
            return CellData(
                value: nameReplace != "" ? nameReplace : data.domain,
                isLabel: data.measure == null);
            break;
          case 1:
            if (data.measure != null) result = data.measure.first;
            break;
          case 2:
            if (data.measure != null) result = data.measure.second;
            break;
          case 3:
            if (data.measure != null && data.measure.first != null && data.measure.second != null)
              result = (data.measure.second - data.measure.first);
            break;
        }
        if (index == 3 && result != null && result != 0) {
          if (result > 0) imagePath = 'images/arrow_up.svg';
          if (result < 0) imagePath = 'images/arrow_down.svg';
        }

        if (result != null) {
          String value;
          if (result is int) {
            value = result.toString();
          } else {
            if (data.measure.isRatio) {
              value = result.toStringAsFixed(2);
            } else {
              value = (result * 100).toStringAsFixed(2) + "%";
            }
          }

          return CellData(value: value, svgImagePath: imagePath, imageX: 26, imageY: 16);
        } else {
          return CellData(value: "");
        }
      },
    );
  }
}

class TypedPair<F, S> {
  final F first;
  final S second;
  final bool isRatio;
  final String nameReplace;

  const TypedPair(
    this.first,
    this.second, {
    this.isRatio = false,
    this.nameReplace = '',
  });

  @override
  String toString() {
    return 'TypedPair{first: $first, second: $second, isRatio: $isRatio}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
