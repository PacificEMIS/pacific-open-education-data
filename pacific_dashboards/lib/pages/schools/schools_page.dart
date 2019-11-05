import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';

class SchoolsPage extends StatefulWidget {
  SchoolsPage({Key key}) : super(key: key);

  static const String kRoute = '/Schools';

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends State<SchoolsPage> {
  bool areFiltersVisible = false;

  void updateFiltersVisibility(BuildContext context) {
    setState(() {
      areFiltersVisible =
          BlocProvider.of<SchoolsBloc>(context).state is UpdatedSchoolsState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SchoolsBloc, SchoolsState>(
      listener: (context, state) {
        updateFiltersVisibility(context);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: PlatformAppBar(
          iconTheme: new IconThemeData(color: AppColors.kWhite),
          backgroundColor: AppColors.kAppBarBackground,
          actions: [
            Visibility(
              visible: areFiltersVisible,
              child: IconButton(
                icon: Icon(
                  Icons.tune,
                  color: AppColors.kWhite,
                ),
                onPressed: () {
                  _openFilters(context);
                },
              ),
            ),
          ],
          title: Text(
            AppLocalizations.schools,
            style: TextStyle(
              color: AppColors.kWhite,
              fontSize: 18.0,
              fontFamily: "Noto Sans",
            ),
          ),
        ),
        body: BlocBuilder<SchoolsBloc, SchoolsState>(
          builder: (context, state) {
            if (state is LoadingSchoolsState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is UpdatedSchoolsState) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ChartWithTable(
                      key: ObjectKey(state.data.enrollmentByState),
                      title: AppLocalizations.schoolsEnrollmentByState,
                      data: state.data.enrollmentByState,
                      chartType: ChartType.bar,
                      tableKeyName: AppLocalizations.state,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    ChartWithTable(
                      key: ObjectKey(state.data.enrollmentByAuthority),
                      title: AppLocalizations.schoolsEnrollmentByAuthority,
                      data: state.data.enrollmentByAuthority,
                      chartType: ChartType.pie,
                      tableKeyName: AppLocalizations.authority,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    ChartWithTable(
                      key: ObjectKey(state.data.enrollmentByPrivacy),
                      title: AppLocalizations.schoolsEnrollmentGovtNonGovt,
                      data: state.data.enrollmentByPrivacy,
                      chartType: ChartType.pie,
                      tableKeyName: AppLocalizations.publicPrivate,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    MultiTable(
                      key: ObjectKey(state.data.enrollmentByAgeAndEducation),
                      title:
                          AppLocalizations.schoolsEnrollmentByAgeEducationLevel,
                      firstColumnName: AppLocalizations.age,
                      data: state.data.enrollmentByAgeAndEducation,
                      keySortFunc: _sortEnrollmentByAgeAndEducation,
                    ),
                    MultiTable(
                      key:
                          ObjectKey(state.data.enrollmentBySchoolLevelAndState),
                      title: AppLocalizations
                          .schoolsEnrollmentBySchoolTypeStateAndGender,
                      firstColumnName: AppLocalizations.schoolType,
                      data: state.data.enrollmentBySchoolLevelAndState,
                    )
                  ],
                ),
              );
            }

            throw FallThroughError();
          },
        ),
      ),
    );
  }

  int _sortEnrollmentByAgeAndEducation(String lv, String rv) {
    // formats like 1-12
    final lvParts = lv.split('-');
    if (lvParts.length < 1) {
      return -1;
    }

    final rvParts = rv.split('-');
    if (rvParts.length < 1) {
      return 1;
    }

    try {
      final lvNum = int.tryParse(lvParts.first);
      final rvNum = int.tryParse(rvParts.first);
      return lvNum.compareTo(rvNum);
    } catch (_) {
      return lvParts.first.compareTo(rvParts.first);
    }
  }

// TODO: rewrite filters
  void _openFilters(BuildContext context) {
    final state = BlocProvider.of<SchoolsBloc>(context).state;
    if (state is UpdatedSchoolsState) {
      final model = state.data.rawModel;

      Navigator.push<List<FilterBloc>>(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(blocs: [
            FilterBloc(
                filter: model.yearFilter,
                defaultSelectedKey: model.yearFilter.getMax()),
            FilterBloc(
                filter: model.stateFilter,
                defaultSelectedKey: AppLocalizations.displayAllStates),
            FilterBloc(
                filter: model.authorityFilter,
                defaultSelectedKey: AppLocalizations.displayAllAuthority),
            FilterBloc(
                filter: model.govtFilter,
                defaultSelectedKey: AppLocalizations.displayAllGovernment),
            FilterBloc(
                filter: model.schoolLevelFilter,
                defaultSelectedKey: AppLocalizations.displayAllLevelFilters),
          ]);
        }),
      ).then((filterBlocs) {
        if (filterBlocs != null) {
          _applyFilters(context, filterBlocs);
        }
      });
    }
  }

  void _applyFilters(BuildContext context, List<FilterBloc> filterBlocs) {
    final state = BlocProvider.of<SchoolsBloc>(context).state;
    if (state is UpdatedSchoolsState) {
      final model = state.data.rawModel;
      model.updateYearFilter(filterBlocs[0].filter);
      model.updateStateFilter(filterBlocs[1].filter);
      model.updateAuthorityFilter(filterBlocs[2].filter);
      model.updateGovtFilter(filterBlocs[3].filter);
      model.updateSchoolLevelFilter(filterBlocs[4].filter);
      BlocProvider.of<SchoolsBloc>(context)
          .add(FiltersAppliedSchoolsEvent(updatedModel: model));
    }
  }
}
