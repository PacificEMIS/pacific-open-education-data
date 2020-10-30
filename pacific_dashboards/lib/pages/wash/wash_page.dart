import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/wash/components/totals/totals_view_data.dart';
import 'package:pacific_dashboards/pages/wash/wash_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import 'components/toilets/toilets_component.dart';
import 'components/toilets/toilets_data.dart';
import 'components/totals/total_component.dart';
import 'components/water/water_component.dart';
import 'components/water/water_data.dart';

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
                StreamBuilder<WashTotalsViewData>(
                  stream: viewModel.totalsDataStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 100,
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TitleWidget(text: 'washDistrictTotalsTitle'),
                        TotalsComponent(
                          data: snapshot.data,
                          onQuestionSelectorPressed: viewModel.onQuestionSelectorPressed,
                        ),
                      ],
                    );
                  },
                ),
                StreamBuilder<WashToiletViewData>(
                  stream: viewModel.toiletsDataStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 100,
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TitleWidget(text: 'washToiletsTitle'),
                        ToiletsComponent(
                          data: snapshot.data,
                        ),
                      ],
                    );
                  },
                ),
                StreamBuilder<WashWaterViewData>(
                  stream: viewModel.waterDataStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 100,
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TitleWidget(text: 'washWaterSourcesTitle'),
                        WaterComponent(
                          data: snapshot.data,
                        ),
                      ],
                    );
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
    if (filters == null) return;
    viewModel.onFiltersChanged(filters);
  }
}

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
        _text.localized(context),
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
