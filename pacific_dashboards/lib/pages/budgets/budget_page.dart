import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/budgets/budget_data.dart';
import 'package:pacific_dashboards/pages/budgets/budget_view_model.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';
import 'components/enroll_data_by_gnp_government_component.dart';
import 'components/spending_by_district_component.dart';

class BudgetsPage extends MvvmStatefulWidget {
  static String kRoute = '/Budgets';

  BudgetsPage({
    Key key,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createBudgetsViewModel(ctx),
        );

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends MvvmState<BudgetViewModel, BudgetsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('budgetsDashboardsTitle'.localized(context)),
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: PageNoteWidget(noteStream: viewModel.noteStream),
                ),
                StreamBuilder<BudgetData>(
                  stream: viewModel.dataStream,
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          //GNP and Government Spending Actual
                          _TitleWidget(
                            text:
                                '${'budgetsGnpAndGovernmentSpendingActualExpense'.localized(context)} ${snapshot.data.year}',
                          ),
                          _GnpAndGovernmentSpendingActualExpense(
                            data: snapshot
                                .data.dataByGnpAndGovernmentSpendingActual,
                          ),
                          //-- GNP and Government Spending Budgeted
                          _TitleWidget(
                            text:
                                '${'budgetsGnpAndGovernmentSpendingBudgetedExpense'.localized(context)} ${snapshot.data.year}',
                          ),
                          _GnpAndGovernmentSpendingActualExpense(
                            data: snapshot
                                .data.dataByGnpAndGovernmentSpendingBudgeted,
                          ),
                          //-- Spending By States
                          _TitleWidget(
                            text:
                                '${'budgetsSpendingByDistrict'.localized(context)} ${snapshot.data.year}',
                          ),
                          _SpendingBySector(
                            data: snapshot.data.dataSpendingBySector,
                          ),
                          // //-- Spending By Sector
                          _TitleWidget(
                            text:
                                '${'budgetsSpendingBySector'.localized(context)} ${snapshot.data.year}',
                          ),
                          SpendingByDistrictComponent(
                            data: snapshot.data.dataSpendingBySectorAndYear,
                            dataFiltered: snapshot
                                .data.dataSpendingBySectorAndYearFiltered,
                            domain: 'budgetsSectorsDomain',
                          ),
                          _TitleWidget(
                            text:
                                '${'budgetsSpendingByDistrict'.localized(context)} ${snapshot.data.year}',
                          ),
                          SpendingByDistrictComponent(
                            data: snapshot.data.dataSpendingByDistrict,
                            dataFiltered:
                                snapshot.data.dataSpendingByDistrictFiltered,
                            domain: 'budgetsStatesDomain',
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
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

enum _GovtTab { gnp, govtExpenditure }
enum _SpendingTab { ece, primary, secondary, total }

class _TitleWidget extends StatelessWidget {
  final String _text;

  const _TitleWidget({
    Key key,
    @required String text,
  })  : assert(text != null),
        _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 0.0,
        top: 10.0,
      ),
      child: Text(
        _text,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

class _GnpAndGovernmentSpendingActualExpense extends StatelessWidget {
  final List<DataByGnpAndGovernmentSpending> _data;

  const _GnpAndGovernmentSpendingActualExpense({
    Key key,
    @required List<DataByGnpAndGovernmentSpending> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MiniTabLayout(
      tabs: _GovtTab.values,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _GovtTab.govtExpenditure:
            return 'budgetsGovtExpenditure'.localized(context);
          case _GovtTab.gnp:
            return 'budgetsGnpColumn'.localized(context);
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _GovtTab.gnp:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.gnp,
              data: _data,
            );
          case _GovtTab.govtExpenditure:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.govt,
              data: _data,
            );
        }
        throw FallThroughError();
      },
    );
  }
}

class _SpendingBySector extends StatelessWidget {
  final List<DataSpendingBySector> _data;

  const _SpendingBySector({
    Key key,
    @required List<DataSpendingBySector> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_data.length == 0)
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'labelNoData'.localized(context),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );

    return MiniTabLayout(
      tabs: _SpendingTab.values,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _SpendingTab.ece:
            return 'budgetsEce'.localized(context);
          case _SpendingTab.primary:
            return 'budgetsPrimaryEducation'.localized(context);
          case _SpendingTab.secondary:
            return 'budgetsSecondaryEducation'.localized(context);
          case _SpendingTab.total:
            return 'labelTotal'.localized(context);
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _SpendingTab.ece:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.sectorEce,
              data: _data,
            );
          case _SpendingTab.primary:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.sectorPrimary,
              data: _data,
            );
          case _SpendingTab.secondary:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.sectorSecondary,
              data: _data,
            );
          case _SpendingTab.total:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
              type: SpendingComponentType.sectorsTotal,
              data: _data,
            );
        }
        throw FallThroughError();
      },
    );
  }
}
