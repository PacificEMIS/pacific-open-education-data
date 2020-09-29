import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/wash/components/toilets_component.dart';
import 'package:pacific_dashboards/pages/wash/components/total_component.dart';
import 'package:pacific_dashboards/pages/wash/wash_data.dart';
import 'package:pacific_dashboards/pages/wash/wash_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class WashPage extends MvvmStatefulWidget {
  static String kRoute = '/Wash';

  WashPage({
    Key key,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createWashViewModel(ctx),
        );

  @override
  _WashPageState createState() => _WashPageState();
}

class _WashPageState extends MvvmState<WashViewModel, WashPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('homeSectionWash'.localized(context)),
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
              StreamBuilder<WashData>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: PlatformProgressIndicator(),
                    );
                  } else {
                    var list = <Widget>[
                      _titleWidget(context, 'washDashboardsTitle', true),
                      _titleWidget(context, 'districtTotals', false),
                      TotalComponent(data: snapshot.data.washModelList),
                      _titleWidget(context, 'toilets', false),
                      ToiletsComponent(data: snapshot.data.toiletsModelList),
                      _titleWidget(context, 'waterSources', false),
                    ];
                    var washWidgetList = list;
                    return Column(
                      children: washWidgetList,
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
