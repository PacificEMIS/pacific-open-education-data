import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/teachers/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
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

  void updateFiltersVisibility(BuildContext context) {
    setState(() {
      areFiltersVisible =
          BlocProvider.of<TeachersBloc>(context).state is UpdatedTeachersState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeachersBloc, TeachersState>(
      listener: (context, state) {
        updateFiltersVisibility(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
            AppLocalizations.teachers,
            style: TextStyle(
              color: AppColors.kWhite,
              fontSize: 18.0,
              fontFamily: "Noto Sans",
            ),
          ),
        ),
        body: BlocBuilder<TeachersBloc, TeachersState>(
          builder: (context, state) {
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

  // TODO: rewrite filters
  void _openFilters(BuildContext context) {
    final state = BlocProvider.of<TeachersBloc>(context).state;
    if (state is UpdatedTeachersState) {
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
    final state = BlocProvider.of<TeachersBloc>(context).state;
    if (state is UpdatedTeachersState) {
      final model = state.data.rawModel;
      model.updateYearFilter(filterBlocs[0].filter);
      model.updateStateFilter(filterBlocs[1].filter);
      model.updateAuthorityFilter(filterBlocs[2].filter);
      model.updateGovtFilter(filterBlocs[3].filter);
      model.updateSchoolLevelFilter(filterBlocs[4].filter);
      BlocProvider.of<TeachersBloc>(context)
          .add(FiltersAppliedTeachersEvent(updatedModel: model));
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
      padding: EdgeInsets.all(16.0),
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
            key: ObjectKey(_data.teachersByState),
            title: AppLocalizations.teachersByState,
            data: _data.teachersByState,
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
