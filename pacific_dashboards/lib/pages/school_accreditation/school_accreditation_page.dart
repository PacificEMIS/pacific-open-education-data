import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import 'package:pacific_dashboards/pages/school_accreditation/bloc/bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/module_note.dart';
import 'package:pacific_dashboards/shared_ui/platform_alert_dialog.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';

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
        if (state is ErrorState) {
          _handleErrorState(state, context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PlatformAppBar(
          actions: <Widget>[
            IconButton(
              icon: SvgPicture.asset('images/filter.svg'),
              onPressed: () {
                _openFilters(context);
              },
            ),
          ],
          title: Text(AppLocalizations.schoolAccreditations),
        ),
        body: BlocBuilder<AccreditationBloc, AccreditationState>(
          condition: (prevState, currentState) => !(currentState is ErrorState),
          builder: (context, state) {
            if (state is InitialAccreditationState) {
              return Container();
            }

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

  void _handleErrorState(AccreditationState state, BuildContext context) {
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
    final state = BlocProvider.of<AccreditationBloc>(context).state;
    if (state is UpdatedAccreditationState) {
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
    final state = BlocProvider.of<AccreditationBloc>(context).state;
    if (state is UpdatedAccreditationState) {
      BlocProvider.of<AccreditationBloc>(context)
          .add(FiltersAppliedAccreditationEvent(filters: filters));
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_data.note != null)
            ModuleNote(
              note: _data.note,
            ),
          TileWidget(
            title: Text(
              AppLocalizations.accreditationProgress,
              style: Theme.of(context).textTheme.display1,
            ),
            body: ChartFactory.getStackedHorizontalBarChartViewByData(
              chartData: _data.accreditationProgressData,
              colorFunc: _levelIndexToColor,
            ),
          ),
          const SizedBox(height: 16),
          TileWidget(
            title: Text(
              AppLocalizations.districtStatus,
              style: Theme.of(context).textTheme.display1,
            ),
            body: ChartFactory.getStackedHorizontalBarChartViewByData(
              chartData: _data.districtStatusData,
              colorFunc: _levelIndexToColor,
            ),
          ),
          const SizedBox(height: 16),
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
      title: Text(
        _title,
        style: Theme.of(context).textTheme.display1,
      ),
      body: Column(
        children: [
          AccreditationTableWidget(
            title: 'Evaluated in $_year',
            firstColumnName: _firstColumnName,
            data: _data.evaluatedData,
          ),
          AccreditationTableWidget(
            title: 'Cumulative up to $_year',
            firstColumnName: _firstColumnName,
            data: _data.cumulatedData,
          ),
        ],
      ),
    );
  }
}
