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
                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 18),
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
    print(_indicators.first.sector.teachers);
    print(_indicators.first.sector.toJson());
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
                        data: <String, Pair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': Pair(_indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': Pair(_indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          // 'indicatorsNumberOfSchools': Pair(
                          //     _indicators.first.schoolCount.count,
                          //     _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation':
                              Pair(_indicators.first.enrolment.population, _indicators.second.enrolment.population),
                          'indicatorsTotalEnrolment':
                              Pair(_indicators.first.enrolment.enrol, _indicators.second.enrolment.enrol),
                          'indicatorsOfficialAgeEnrolment': Pair(_indicators.first.enrolment.enrolOfficialAge,
                              _indicators.second.enrolment.enrolOfficialAge),
                          'indicatorsGrossEnrolment': Pair(_indicators.first.enrolment.grossEnrolmentRatio,
                              _indicators.second.enrolment.grossEnrolmentRatio),
                          'indicatorsNetEnrolment': Pair(_indicators.first.enrolment.netEnrolmentRatio,
                              _indicators.second.enrolment.netEnrolmentRatio),

                          'indicatorsQuality': null,
                          'numberOfTeachers':
                              Pair(_indicators.first.sector.teachers, _indicators.second.sector.teachers),
                          'certified': Pair(_indicators.first.sector.certified, _indicators.second.sector.certified),
                          'certifiedPercentage': Pair(_indicators.first.sector.certifiedPercent,
                              _indicators.second.sector.certifiedPercent),
                          'qualified': Pair(_indicators.first.sector.qualified, _indicators.second.sector.qualified),
                          'qualifiedPercentage': Pair(_indicators.first.sector.qualifiedPercent,
                              _indicators.second.sector.qualifiedPercent),
                          'pupilTeachersRation': Pair(_indicators.first.sector.pupilTeacherRatio,
                              _indicators.second.sector.pupilTeacherRatio),
                          'pupilCertifiedTeachersRation': Pair(_indicators.first.sector.pupilTeacherRatioCertified,
                              _indicators.second.sector.pupilTeacherRatioCertified),
                          'pupilQualifiedTeachersRation': Pair(_indicators.first.sector.pupilTeacherRatioCertQual,
                              _indicators.second.sector.pupilTeacherRatioCertQual),

                          'indicatorsProcess': null,
                          'repeatersNumber':
                              Pair(_indicators.first.enrolment.repeaters, _indicators.second.enrolment.repeaters),
                          'repetitionRate': Pair(
                              _indicators.first.enrolment.repeaters == 0
                                  || _indicators.first.previous == null
                                  || _indicators.first.previous.enrolment.enrol == 0
                                  ? null
                                  : _indicators.first.enrolment.repeaters / _indicators.first.previous.enrolment.enrol,
                              _indicators.first.enrolment.repeaters == 0
                                  || _indicators.first.previous == null
                                  || _indicators.first.previous.enrolment.enrol == 0
                                  ? null
                                  : _indicators.second.enrolment.repeaters / _indicators.second.previous.enrolment.enrol
                          ),

                          'indicatorsOutcome': null,
                          'indicatorsPopulation':
                              Pair(_indicators.first.enrolment.population, _indicators.second.enrolment.population),
                          'indicatorsTotalEnrolment':
                              Pair(_indicators.first.enrolment.enrol, _indicators.second.enrolment.enrol),
                          'indicatorsOfficialAgeEnrolment': Pair(_indicators.first.enrolment.enrolOfficialAge,
                              _indicators.second.enrolment.enrolOfficialAge),
                          'indicatorsGrossEnrolment': Pair(_indicators.first.enrolment.grossEnrolmentRatio,
                              _indicators.second.enrolment.grossEnrolmentRatio),
                          'indicatorsNetEnrolment': Pair(_indicators.first.enrolment.netEnrolmentRatio,
                              _indicators.second.enrolment.netEnrolmentRatio),

                          // 'indicatorsPopulation': null,
                          'survivalRate':
                              Pair(_indicators.first.enrolment.population, _indicators.second.enrolment.population),
                          'intake': Pair(_indicators.first.enrolment.intake, _indicators.second.enrolment.intake),
                          'grossIntakeRatio': Pair(_indicators.first.enrolment.grossIntakeRatio,
                              _indicators.second.enrolment.grossIntakeRatio),
                          'netIntake':
                              Pair(_indicators.first.enrolment.netIntake, _indicators.second.enrolment.netIntake),
                          'netIntakeRatio': Pair(
                              _indicators.first.enrolment.netIntakeRatio, _indicators.second.enrolment.netIntakeRatio),
                          'grossIRLG': Pair(_indicators.first.enrolmentLastGrade.grossIntakeRatio,
                              _indicators.second.enrolmentLastGrade.grossIntakeRatio),
                        },
                      );
                    case _GenderTab.male:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, Pair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': Pair(_indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': Pair(_indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          //'indicatorsNumberOfSchools': Pair(
                          //    _indicators.first.schoolCount.count,
                          //    _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': Pair(
                              _indicators.first.enrolment.populationMale, _indicators.second.enrolment.populationMale),
                          'indicatorsTotalEnrolment':
                              Pair(_indicators.first.enrolment.enrolMale, _indicators.second.enrolment.enrolMale),
                          'indicatorsOfficialAgeEnrolment': Pair(_indicators.first.enrolment.enrolOfficialAgeMale,
                              _indicators.second.enrolment.enrolOfficialAgeMale),
                          'indicatorsGrossEnrolment': Pair(_indicators.first.enrolment.grossEnrolmentRatioMale,
                              _indicators.second.enrolment.grossEnrolmentRatioMale),
                          'indicatorsNetEnrolment': Pair(_indicators.first.enrolment.netEnrolmentRatioMale,
                              _indicators.second.enrolment.netEnrolmentRatioMale),
                        },
                      );
                    case _GenderTab.female:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, Pair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': Pair(_indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': Pair(_indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          //'indicatorsNumberOfSchools': Pair(
                          //    _indicators.first.schoolCount.count,
                          //    _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': Pair(_indicators.first.enrolment.populationFemale,
                              _indicators.second.enrolment.populationFemale),
                          'indicatorsTotalEnrolment':
                              Pair(_indicators.first.enrolment.enrolFemale, _indicators.second.enrolment.enrolFemale),
                          'indicatorsOfficialAgeEnrolment': Pair(_indicators.first.enrolment.enrolOfficialAgeFemale,
                              _indicators.second.enrolment.enrolOfficialAgeFemale),
                          'indicatorsGrossEnrolment': Pair(_indicators.first.enrolment.grossEnrolmentRatioFemale,
                              _indicators.second.enrolment.grossEnrolmentRatioFemale),
                          'indicatorsNetEnrolment': Pair(_indicators.first.enrolment.netEnrolmentRatioFemale,
                              _indicators.second.enrolment.netEnrolmentRatioFemale),
                        },
                      );
                    case _GenderTab.femalePercent:
                      return _IndicatorsTable(
                        indicators: _indicators,
                        data: <String, Pair<num, num>>{
                          'indicatorsContext': null,
                          'indicatorsYearsOfSchooling': Pair(_indicators.first.enrolment.yearsOfSchooling,
                              _indicators.second.enrolment.yearsOfSchooling),
                          'indicatorsStartAge': Pair(_indicators.first.enrolment.officialStartAge,
                              _indicators.second.enrolment.officialStartAge),
                          //'indicatorsNumberOfSchools': Pair(
                          //    _indicators.first.schoolCount.count,
                          //    _indicators.second.schoolCount.count),
                          'indicatorsDemographic': null,
                          'indicatorsPopulation': Pair(
                              _Percent(
                                  _indicators.first.enrolment.populationFemale, _indicators.first.enrolment.population),
                              _Percent(_indicators.second.enrolment.populationFemale,
                                  _indicators.second.enrolment.population)),
                          'indicatorsTotalEnrolment': Pair(
                              _Percent(_indicators.first.enrolment.enrolFemale, _indicators.first.enrolment.enrol),
                              _Percent(_indicators.second.enrolment.enrolFemale, _indicators.second.enrolment.enrol)),
                          'indicatorsOfficialAgeEnrolment': Pair(
                              _Percent(_indicators.first.enrolment.enrolOfficialAgeFemale,
                                  _indicators.first.enrolment.enrolOfficialAge),
                              _Percent(_indicators.second.enrolment.enrolOfficialAgeFemale,
                                  _indicators.second.enrolment.enrolOfficialAge)),
                          'indicatorsGrossEnrolment': Pair(
                              _Percent(_indicators.first.enrolment.grossEnrolmentRatioFemale,
                                  _indicators.first.enrolment.grossEnrolmentRatio),
                              _Percent(_indicators.second.enrolment.grossEnrolmentRatioFemale,
                                  _indicators.second.enrolment.grossEnrolmentRatio)),
                          'indicatorsNetEnrolment': Pair(
                              _Percent(_indicators.first.enrolment.netEnrolmentRatioFemale,
                                  _indicators.first.enrolment.netEnrolmentRatio),
                              _Percent(_indicators.second.enrolment.netEnrolmentRatioFemale,
                                  _indicators.second.enrolment.netEnrolmentRatio)),
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
      {Key key, @required Pair<Indicator, Indicator> indicators, @required Map<String, Pair<num, num>> data})
      : _indicators = indicators,
        _data = data,
        super(key: key);

  final Pair<Indicator, Indicator> _indicators;
  final Map<String, Pair<num, num>> _data;

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
            return CellData(value: data.domain, isLabel: data.measure == null);
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
          return CellData(
              value: result is int ? result.toString() : (result * 100).toStringAsFixed(2) + "%",
              svgImagePath: imagePath,
              imageX: 26,
              imageY: 16);
        } else {
          return CellData(value: "");
        }
      },
    );
  }
}
