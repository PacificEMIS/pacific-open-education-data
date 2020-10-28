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
                      var list = <Widget>[
                        //GNP and Government Spending Actual
                        _titleWidget(
                          context,
                          '${'budgetsGnpAndGovernmentSpendingActualExpense'.localized(context)} ${snapshot.data.year}',
                          false,
                        ),
                        _gNpAndGovernmentSpendingActualExpense(
                          context,
                          snapshot.data.dataByGnpAndGovernmentSpendingActual,
                        ),
                        //-- GNP and Government Spending Budgeted
                        _titleWidget(
                          context,
                          '${'budgetsGnpAndGovernmentSpendingBudgetedExpense'.localized(context)} ${snapshot.data.year}',
                          false,
                        ),
                        _gNpAndGovernmentSpendingActualExpense(
                          context,
                          snapshot.data.dataByGnpAndGovernmentSpendingBudgeted,
                        ),
                        //-- Spending By Sector
                        _titleWidget(
                          context,
                          '${'budgetsSpendingByDistrict'.localized(context)} ${snapshot.data.year}',
                          false,
                        ),
                        _spendingBySector(
                          context,
                          snapshot.data.dataSpendingBySector,
                        ),
                        //-- Spending By Sector
                        _titleWidget(
                          context,
                          '${'budgetsSpendingBySector'.localized(context)} ${snapshot.data.year}',
                          false,
                        ),
                        SpendingByDistrictComponent(
                          data: snapshot.data.dataSpendingBySectorAndYear,
                          dataFiltered:
                              snapshot.data.dataSpendingBySectorAndYearFiltered, domain: 'sectors'
                        ),
                        _titleWidget(
                          context,
                          '${'budgetsSpendingByDistrict'.localized(context)} ${snapshot.data.year}',
                          false,
                        ),
                        SpendingByDistrictComponent(
                          data: snapshot.data.dataSpendingByDistrict,
                          dataFiltered:
                              snapshot.data.dataSpendingByDistrictFiltered, domain: 'schoolsAccreditationDashboardsStateDomain'
                        ),
                      ];
                      var budgetWidgetList = list;
                      return Column(
                        children: budgetWidgetList,
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

  MiniTabLayout _gNpAndGovernmentSpendingActualExpense(
      BuildContext context, List<DataByGnpAndGovernmentSpending> data) {
    return MiniTabLayout(
      tabs: _GovtTab.values,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _GovtTab.govtExpenditure:
            return 'govtExpenditure'.localized(context);
          case _GovtTab.gNP:
            return 'gNP'.localized(context);
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _GovtTab.gNP:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'GNP', data: data);
          case _GovtTab.govtExpenditure:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'Govt', data: data);
        }
        throw FallThroughError();
      },
    );
  }

  Widget _spendingBySector(
      BuildContext context, List<DataSpendingBySector> data) {
    if (data.length == 0)
      return Center(
        child: Text(
          'labelNoData'.localized(context),
          style: Theme.of(context).textTheme.headline5,
        ),
      );

    return MiniTabLayout(
      tabs: _SpendingTab.values,
      tabNameBuilder: (tab) {
        switch (tab) {
          case _SpendingTab.eCE:
            return 'eCE'.localized(context);
          case _SpendingTab.primary:
            return 'primaryEducation'.localized(context);
          case _SpendingTab.secondary:
            return 'secondaryEducation'.localized(context);
          case _SpendingTab.total:
            return 'labelTotal'.localized(context);
        }
        throw FallThroughError();
      },
      builder: (ctx, tab) {
        switch (tab) {
          case _SpendingTab.eCE:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'ECE', data: data);
          case _SpendingTab.primary:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'Primary', data: data);
          case _SpendingTab.secondary:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'Secondary', data: data);
          case _SpendingTab.total:
            return EnrollDataByGnpAndGovernmentSpendingComponent(
                type: 'Total', data: data);
        }
        throw FallThroughError();
      },
    );
  }

  Container _titleWidget(BuildContext context, String text, bool isTitle) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0, top: 10.0),
      child: Text(
        text,
        style: isTitle == true
            ? Theme.of(context).textTheme.headline3.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
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

enum _GovtTab { govtExpenditure, gNP }
enum _SpendingTab { eCE, primary, secondary, total }
