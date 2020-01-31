import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/teachers/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/platform_alert_dialog.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';

class TeachersPage extends StatefulWidget {
  TeachersPage({
    Key key,
  }) : super(key: key);

  static const String kRoute = '/Teachers';

  @override
  State<StatefulWidget> createState() {
    return TeachersPageState();
  }
}

class TeachersPageState extends State<TeachersPage> {
  bool areFiltersVisible = false;

  void _updateFiltersVisibility(BuildContext context) {
    setState(() {
      areFiltersVisible =
          BlocProvider.of<TeachersBloc>(context).state is UpdatedTeachersState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeachersBloc, TeachersState>(
      listener: (context, state) {
        _updateFiltersVisibility(context);
        if (state is ErrorState) {
          _handleErrorState(state, context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PlatformAppBar(
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
          title: Text(AppLocalizations.teachers),
        ),
        body: BlocBuilder<TeachersBloc, TeachersState>(
          condition: (prevState, currentState) => !(currentState is ErrorState),
          builder: (context, state) {
            if (state is InitialTeachersState) {
              return Container();
            }

            if (state is LoadingTeachersState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is UpdatedTeachersState) {
              return _LoadedContent(data: state.data);
            }

            throw FallThroughError();
          },
        ),
      ),
    );
  }

  void _handleErrorState(TeachersState state, BuildContext context) {
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

  void _openFilters(BuildContext context) {
    final state = BlocProvider.of<TeachersBloc>(context).state;
    if (state is UpdatedTeachersState) {
      Navigator.push<BuiltList<Filter>>(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(
            filters: state.data.filters,
          );
        }),
      ).then((filters) => _applyFilters(context, filters));
    }
  }

  void _applyFilters(BuildContext context, BuiltList<Filter> filters) {
    if (filters == null) {
      return;
    }
    final state = BlocProvider.of<TeachersBloc>(context).state;
    if (state is UpdatedTeachersState) {
      BlocProvider.of<TeachersBloc>(context)
          .add(FiltersAppliedTeachersEvent(filters: filters));
    }
  }
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({
    Key key,
    @required TeachersPageData data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  final TeachersPageData _data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ChartWithTable(
            key: ObjectKey(_data.teachersByAuthority),
            title: AppLocalizations.teachersByAuthority,
            data: _data.teachersByAuthority,
            chartType: ChartType.pie,
            tableKeyName: AppLocalizations.authority,
            tableValueName: AppLocalizations.teachers,
          ),
          ChartWithTable(
            key: ObjectKey(_data.teachersByPrivacy),
            title: AppLocalizations.teachersEnrollmentGovtNonGovt,
            data: _data.teachersByPrivacy,
            chartType: ChartType.pie,
            tableKeyName: AppLocalizations.publicPrivate,
            tableValueName: AppLocalizations.teachers,
          ),
          ChartWithTable(
            key: ObjectKey(_data.teachersByDistrict),
            title: AppLocalizations.teachersByState,
            data: _data.teachersByDistrict,
            chartType: ChartType.bar,
            tableKeyName: AppLocalizations.state,
            tableValueName: AppLocalizations.teachers,
          ),
          MultiTable(
            key: ObjectKey(_data.teachersBySchoolLevelStateAndGender),
            title: AppLocalizations.teacherBySchoolTypeStateAndGender,
            firstColumnName: AppLocalizations.schoolLevels,
            data: _data.teachersBySchoolLevelStateAndGender,
            keySortFunc: (lv, rv) => lv.compareTo(rv),
          ),
        ],
      ),
    );
  }
}
