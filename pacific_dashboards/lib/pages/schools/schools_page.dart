import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/module_note.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/platform_alert_dialog.dart';
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
        if (state is ErrorState) {
          _handleErrorState(state, context);
        }
      },
      child: Scaffold(
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.schools),
          actions: [
            Visibility(
              visible: areFiltersVisible,
              child: IconButton(
                icon: SvgPicture.asset('images/filter.svg'),
                onPressed: () {
                  _openFilters(context);
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<SchoolsBloc, SchoolsState>(
          buildWhen: (prevState, currentState) => !(currentState is ErrorState),
          builder: (context, state) {
            if (state is InitialSchoolsState) {
              return Container();
            }

            if (state is LoadingSchoolsState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is UpdatedSchoolsState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.data.note != null)
                      ModuleNote(
                        note: state.data.note,
                      ),
                    ChartWithTable(
                      key: ValueKey(state.data.enrolByDistrict),
                      title: AppLocalizations.schoolsEnrollmentByState,
                      data: state.data.enrolByDistrict,
                      chartType: ChartType.bar,
                      tableKeyName: AppLocalizations.state,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    ChartWithTable(
                      key: ValueKey(state.data.enrolByAuthority),
                      title: AppLocalizations.schoolsEnrollmentByAuthority,
                      data: state.data.enrolByAuthority,
                      chartType: ChartType.pie,
                      tableKeyName: AppLocalizations.authority,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    ChartWithTable(
                      key: ValueKey(state.data.enrolByPrivacy),
                      title: AppLocalizations.schoolsEnrollmentGovtNonGovt,
                      data: state.data.enrolByPrivacy,
                      chartType: ChartType.pie,
                      tableKeyName: AppLocalizations.publicPrivate,
                      tableValueName: AppLocalizations.schoolsEnrollment,
                    ),
                    MultiTable(
                      key: ValueKey(state.data.enrolByAgeAndEducation),
                      title:
                          AppLocalizations.schoolsEnrollmentByAgeEducationLevel,
                      firstColumnName: AppLocalizations.age,
                      data: state.data.enrolByAgeAndEducation,
                      keySortFunc: _compareEnrollmentByAgeAndEducation,
                    ),
                    MultiTable(
                      key: ValueKey(state.data.enrolBySchoolLevelAndDistrict),
                      title: AppLocalizations
                          .schoolsEnrollmentBySchoolTypeStateAndGender,
                      firstColumnName: AppLocalizations.schoolType,
                      data: state.data.enrolBySchoolLevelAndDistrict,
                      keySortFunc: _compareEnrollmentBySchoolLevelAndState,
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

  void _handleErrorState(SchoolsState state, BuildContext context) {
    if (state is UnknownErrorState) {
      showDialog(
        context: context,
        builder: (buildContext) {
          return PlatformAlertDialog(
            title: AppLocalizations.error,
            message: AppLocalizations.unknownError,
          );
        },
      );
    }
    if (state is ServerUnavailableState) {
      showDialog(
        context: context,
        builder: (buildContext) {
          return PlatformAlertDialog(
            title: AppLocalizations.error,
            message: AppLocalizations.serverUnavailableError,
          );
        },
      );
    }
  }

  int _compareEnrollmentBySchoolLevelAndState(String lv, String rv) {
    return lv.compareTo(rv);
  }

  int _compareEnrollmentByAgeAndEducation(String lv, String rv) {
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

  void _openFilters(BuildContext context) {
    final state = BlocProvider.of<SchoolsBloc>(context).state;
    if (state is UpdatedSchoolsState) {
      Navigator.push<List<Filter>>(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(
            filters: state.data.filters,
          );
        }),
      ).then((filters) => _applyFilters(context, filters));
    }
  }

  void _applyFilters(BuildContext context, List<Filter> filters) {
    if (filters == null) {
      return;
    }
    final state = BlocProvider.of<SchoolsBloc>(context).state;
    if (state is UpdatedSchoolsState) {
      BlocProvider.of<SchoolsBloc>(context)
          .add(FiltersAppliedSchoolsEvent(filters: filters));
    }
  }
}
