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
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
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

class SchoolsPageState
    extends MvvmState<SchoolAccreditationViewModel, SchoolAccreditationsPage> {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PageNoteWidget(noteStream: viewModel.noteStream),
            StreamBuilder<AccreditationData>(
              stream: viewModel.dataStream,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: PlatformProgressIndicator(),
                  );
                } else {
                  return _ContentBody(data: snapshot.data);
                }
              },
            ),
          ],
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
        TileWidget(
          title: Text(
            'schoolsAccreditationDashboardsProgressTitle'.localized(context),
            style: Theme.of(context).textTheme.headline4,
          ),
          body: ChartFactory.getStackedHorizontalBarChartViewByData(
            chartData: _data.accreditationProgressData,
            colorFunc: _levelIndexToColor,
          ),
        ),
        const SizedBox(height: 16),
        TileWidget(
          title: Text(
            'schoolsAccreditationDashboardsDistrictTitle'.localized(context),
            style: Theme.of(context).textTheme.headline4,
          ),
          body: ChartFactory.getStackedHorizontalBarChartViewByData(
            chartData: _data.districtStatusData,
            colorFunc: _levelIndexToColor,
          ),
        ),
        const SizedBox(height: 16),
        _PerformanceTable(
          title: 'schoolsAccreditationDashboardsStatusByStateTitle'
              .localized(context),
          firstColumnName:
              'schoolsAccreditationDashboardsStateDomain'.localized(context),
          year: _data.year,
          data: _data.accreditationStatusByState,
        ),
        _PerformanceTable(
          title: 'schoolsAccreditationDashboardsPerformanceByStandardTitle'
              .localized(context),
          firstColumnName:
              'schoolsAccreditationDashboardsStandardDomain'.localized(context),
          year: _data.year,
          data: _data.performanceByStandard,
        ),
      ],
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
