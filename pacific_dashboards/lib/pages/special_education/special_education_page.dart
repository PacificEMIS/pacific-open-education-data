import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/special_education/componnets/cohort_distribution_component.dart';
import 'package:pacific_dashboards/pages/special_education/componnets/special_education_component.dart';
import 'package:pacific_dashboards/pages/special_education/special_education_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import 'special_education_data.dart';

class SpecialEducationPage extends MvvmStatefulWidget {
  static String kRoute = '/SpecialEducations';

  SpecialEducationPage({
    Key key,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createSpecialEducationViewModel(ctx),
        );

  @override
  _SpecialEducationPageState createState() => _SpecialEducationPageState();
}

class _SpecialEducationPageState
    extends MvvmState<SpecialEducationViewModel, SpecialEducationPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('homeSectionSpecialEducation'.localized(context)),
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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<SpecialEducationData>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: PlatformProgressIndicator(),
                    );
                  } else {
                    var list = <Widget>[
                      _titleWidget(context, 'specialEducationTitle', true),
                      //GNP and Government Spending Actual
                      _titleWidget(context, 'disability', false),
                      SpecialEducationComponent(
                          data: snapshot.data.dataByGender),
                      _titleWidget(context, 'ethnicity', false),
                      SpecialEducationComponent(
                          data: snapshot.data.dataByEthnicity),
                      _titleWidget(
                          context, 'specialEducationEnvironment', false),
                      SpecialEducationComponent(
                          data: snapshot.data.dataBySpecialEdEnvironment),
                      _titleWidget(context, 'englishLearnerStatus', false),
                      SpecialEducationComponent(
                          data: snapshot.data.dataByEnglishLearner),
                      _titleWidget(context, 'cohortDistribution', true),
                      _titleWidget(context, 'byYear', false),
                      CohortDistributionComponent(
                          data: snapshot.data.dataByCohortDistributionByYear),
                      _titleWidget(context, 'byState', false),
                      CohortDistributionComponent(
                          data: snapshot.data.dataByCohortDistributionByState),
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
    );
  }

  Container _titleWidget(BuildContext context, String text, bool isTitle) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0, top: 10.0),
      child: Text(
        text.localized(context),
        style: isTitle == true
            ? Theme.of(context).textTheme.headline3.copyWith(
                  color: Color.fromRGBO(19, 40, 38, 100),
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.headline4.copyWith(
                  color: Color.fromRGBO(19, 40, 38, 100),
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
