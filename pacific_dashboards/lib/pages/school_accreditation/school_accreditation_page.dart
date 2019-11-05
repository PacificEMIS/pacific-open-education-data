import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import 'package:pacific_dashboards/pages/school_accreditation/bloc/bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';
import 'package:pacific_dashboards/shared_ui/title_widget.dart';

class SchoolAccreditationsPage extends StatefulWidget {
  static String kRoute = '/School Accreditations';

  SchoolAccreditationsPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends State<SchoolAccreditationsPage> {
  bool areFiltersVisible = false;

  void updateFiltersVisibility(BuildContext context) {
    setState(() {
      areFiltersVisible = BlocProvider.of<AccreditationBloc>(context).state
          is UpdatedAccreditationState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccreditationBloc, AccreditationState>(
      listener: (context, state) {
        updateFiltersVisibility(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PlatformAppBar(
          iconTheme: new IconThemeData(color: AppColors.kWhite),
          backgroundColor: AppColors.kAppBarBackground,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.tune,
                color: AppColors.kWhite,
              ),
              onPressed: () {
                _openFilters(context);
              },
            ),
          ],
          title: Text(
            AppLocalizations.schoolAccreditations,
            style: TextStyle(
              color: AppColors.kWhite,
              fontSize: 18.0,
              fontFamily: "Noto Sans",
            ),
          ),
        ),
        body: BlocBuilder<AccreditationBloc, AccreditationState>(
          builder: (context, state) {
            if (state is LoadingAccreditationState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is UpdatedAccreditationState) {
              return _ContentBody(
                data: state.data,
              );
            }

            throw FallThroughError();
          },
        ),
      ),
    );
  }

  // TODO: rewrite filters
  void _openFilters(BuildContext context) {
    final state = BlocProvider.of<AccreditationBloc>(context).state;
    if (state is UpdatedAccreditationState) {
      final model = state.data.rawModel.statesChunk;
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
    final state = BlocProvider.of<AccreditationBloc>(context).state;
    if (state is UpdatedAccreditationState) {
      final model = state.data.rawModel;
      model.statesChunk.updateYearFilter(filterBlocs[0].filter);
      model.statesChunk.updateStateFilter(filterBlocs[1].filter);
      model.statesChunk.updateAuthorityFilter(filterBlocs[2].filter);
      model.statesChunk.updateGovtFilter(filterBlocs[3].filter);
      model.statesChunk.updateSchoolLevelFilter(filterBlocs[4].filter);
      BlocProvider.of<AccreditationBloc>(context)
          .add(FiltersAppliedAccreditationEvent(updatedModel: model));
    }
  }
}

class _ContentBody extends StatelessWidget {
  _ContentBody({
    Key key,
    @required AccreditationData data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  final AccreditationData _data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TileWidget(
            title: TitleWidget(
              AppLocalizations.accreditationProgress,
              AppColors.kRacingGreen,
            ),
            body: ChartFactory.getStackedHorizontalBarChartViewByData(
              chartData: _data.accreditationProgressData,
              colorFunc: _levelIndexToColor,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TileWidget(
            title: TitleWidget(
              AppLocalizations.districtStatus,
              AppColors.kRacingGreen,
            ),
            body: ChartFactory.getStackedHorizontalBarChartViewByData(
              chartData: _data.districtStatusData,
              colorFunc: _levelIndexToColor,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _PerformanceTable(
            title: AppLocalizations.accreditationStatusByState,
            firstColumnName: AppLocalizations.state,
            year: _data.year,
            data: _data.accreditationStatusByState,
          ),
          _PerformanceTable(
            title: AppLocalizations.accreditationPerfomancebyStandard,
            firstColumnName: AppLocalizations.standard,
            year: _data.year,
            data: _data.performanceByStandard,
          ),
        ],
      ),
    );
  }

  Color _levelIndexToColor(int index) {
    return AppColors.kLevels[index];
  }
}

class _PerformanceTable extends StatelessWidget {
  const _PerformanceTable({
    Key key,
    @required String title,
    @required String firstColumnName,
    @required String year,
    @required MultitableData data,
  })  : _data = data,
        _title = title,
        _firstColumnName = firstColumnName,
        _year = year,
        super(key: key);

  final MultitableData _data;
  final String _title;
  final String _firstColumnName;
  final String _year;

  @override
  Widget build(BuildContext context) {
    return TileWidget(
      title: TitleWidget(
        _title,
        AppColors.kRacingGreen,
      ),
      body: Column(
        children: [
          AccreditationTableWidget(
            title: "Evaluated in $_year",
            firstColumnName: _firstColumnName,
            data: _data.evaluatedData,
          ),
          AccreditationTableWidget(
            title: "Cumulative up to $_year",
            firstColumnName: _firstColumnName,
            data: _data.cumulatedData,
          ),
        ],
      ),
    );
  }
}
