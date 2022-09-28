import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import 'package:pacific_dashboards/pages/school_accreditation/school_accreditation_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class SchoolAccreditationsPage extends MvvmStatefulWidget {
  static String kRoute = '/SchoolAccreditations';

  SchoolAccreditationsPage({
    Key key,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createSchoolAccreditationViewModel(ctx),
        );

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends MvvmState<SchoolAccreditationViewModel, SchoolAccreditationsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('schoolsAccreditationDashboardsTitle'.localized(context)),
        actions: <Widget>[
          StreamBuilder<List<Filter>>(
            stream: viewModel.filtersStream,
            builder: (ctx, snapshot) {
              return Visibility(
                visible: snapshot.hasData,
                child: IconButton(
                  icon: SvgPicture.asset('images/filter.svg'),
                  onPressed: () {
                    _openFilters(snapshot.data);
                  },
                ),
              );
            },
          )
        ],
      ),
      body: LoadingStack(
        loadingStateStream: viewModel.activityIndicatorStream,
        errorStateStream: viewModel.errorMessagesStream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageNoteWidget(noteStream: viewModel.noteStream),
              StreamBuilder<AccreditationData>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {
                    return _ContentBody(data: snapshot.data);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilters(List<Filter> filters) {
    Navigator.push<List<Filter>>(
      context,
      MaterialPageRoute(builder: (context) {
        return FilterPage(
          filters: filters,
        );
      }),
    ).then((filters) => _applyFilters(context, filters));
  }

  void _applyFilters(BuildContext context, List<Filter> filters) {
    if (filters == null) {
      return;
    }
    viewModel.onFiltersChanged(filters);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'schoolsAccreditationDashboardsProgressTitle'.localized(context),
          style: Theme.of(context).textTheme.headline4,
        ),
        _buildMiniTabLayoutAccreditationProgress(
            context,
            [
              _data.accreditationProgressByYearData,
              _data.accreditationProgressByYearCumulativeData,
            ],
            _data.year),
        Text(
          'schoolsAccreditationDashboardsProgressByStateTitle'.localized(context),
          style: Theme.of(context).textTheme.headline4,
        ),
        _buildMiniTabLayoutAccreditationProgress(
            context,
            [
              _data.districtStatusData,
              _data.districtStatusCumulativeData,
            ],
            _data.districtStatusData.keys.first), // TODO Update
        Text(
          'schoolsAccreditationDashboardsProgressNationalTitle'.localized(context),
          style: Theme.of(context).textTheme.headline4,
        ),
        _buildMiniTabLayoutAccreditationProgressPieChart(
          context,
          _data.accreditationNationalCumulativeData,
          _data.accreditationNationalEvaluatedData,
        ),
        const SizedBox(height: 16),
        _PerformanceTable(
          title: 'schoolsAccreditationDashboardsStatusByStateTitle'.localized(context),
          firstColumnName: 'schoolsAccreditationDashboardsStateDomain'.localized(context),
          year: _data.year,
          data: _data.accreditationStatusByState,
        ),
        _PerformanceTable(
          title: 'schoolsAccreditationDashboardsPerformanceByStandardTitle'.localized(context),
          firstColumnName: 'schoolsAccreditationDashboardsStandardDomain'.localized(context),
          year: _data.year,
          data: _data.performanceByStandard,
        ),
      ],
    );
  }

  Widget _buildMiniTabLayoutAccreditationProgress(
    BuildContext context,
    List<Map<String, List<int>>> chartData,
    String selectedItem,
  ) {
    return MiniTabLayout(
      tabs: _Tab.values,
      padding: 0.0,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _Tab.cumulative:
            return '${'schoolAccreditationCumulative'.localized(context)} ${_data.year}';
          case _Tab.evaluated:
            return '${'schoolAccreditationEvaluated'.localized(context)} ${_data.year}';
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _Tab.cumulative:
            return ChartFactory.createStackedHorizontalBarChartViewByData(
                chartData: chartData[0], colorFunc: _levelIndexToColor);
          case _Tab.evaluated:
            return ChartFactory.createStackedHorizontalBarChartViewByData(
                chartData: chartData[1], colorFunc: _levelIndexToColor);
        }
        throw FallThroughError();
      },
    );
  }

  Widget _buildMiniTabLayoutAccreditationProgressPieChart(
    BuildContext context,
    List<ChartData> cumulativeData,
    List<ChartData> evaluatedData,
  ) {
    return MiniTabLayout(
      tabs: _Tab.values,
      padding: 0.0,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _Tab.cumulative:
            return '${'schoolAccreditationCumulative'.localized(context)} ${_data.year}';
          case _Tab.evaluated:
            return '${'schoolAccreditationEvaluated'.localized(context)} ${_data.year}';
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _Tab.cumulative:
            return ChartWithTable(
              key: ObjectKey(cumulativeData),
              chartType: ChartType.pie,
              tableKeyName: 'levels'.localized(context),
              tableValueName: 'schoolsDashboardsTitle'.localized(context),
              title: '',
              data: cumulativeData,
            );
          case _Tab.evaluated:
            return ChartWithTable(
              key: ObjectKey(evaluatedData),
              chartType: ChartType.pie,
              tableKeyName: 'levels'.localized(context),
              tableValueName: 'schoolsDashboardsTitle'.localized(context),
              title: '',
              data: evaluatedData,
            );
        }
        throw FallThroughError();
      },
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
        style: Theme.of(context).textTheme.headline4,
      ),
      body: MiniTabLayout(
        tabs: _Tab.values,
        padding: 0.0,
        tabNameBuilder: (tab) {
          switch (tab) {
            case _Tab.evaluated:
              return 'washCumulative'.localized(context);
            case _Tab.cumulative:
              return 'washEvaluated'.localized(context);
          }
          throw FallThroughError();
        },
        builder: (ctx, tab) {
          switch (tab) {
            case _Tab.evaluated:
              return AccreditationTableWidget(
                title: 'Cumulative up to $_year',
                firstColumnName: _firstColumnName,
                data: _data.cumulatedData,
              );
            case _Tab.cumulative:
              return AccreditationTableWidget(
                title: 'Evaluated in $_year',
                firstColumnName: _firstColumnName,
                data: _data.evaluatedData,
              );
          }
          throw FallThroughError();
        },
      ),
    );
  }
}

enum _Tab { cumulative, evaluated }
