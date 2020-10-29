import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/wash/components/toilets_component.dart';
import 'package:pacific_dashboards/pages/wash/wash_data.dart';
import 'package:pacific_dashboards/pages/wash/wash_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import 'components/total_component.dart';
import 'components/water_component.dart';

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
                StreamBuilder<WashData>(
                  stream: viewModel.dataStream,
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      var list = <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          child: Material(
                            color: AppColors.kGrayLight,
                            child: ClipRect(
                              clipBehavior: Clip.hardEdge,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: InkWell(
                                      onTap: () {
                                        _openFilters(snapshot.data.questions);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 280,
                                              child: Text(
                                                'CW.H.2: Are both soap and water currently available at the hand washing facilities?',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        color: CupertinoColors
                                                            .activeBlue),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 30),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _titleWidget(context, 'districtTotals', false),
                        TotalComponent(
                          data: snapshot.data.washModelList,
                          year: snapshot.data.year,
                        ),
                        Container(height: 50),
                        _titleWidget(context, 'toilets', false),
                        ToiletsComponent(
                            data: snapshot.data.toiletsModelList,
                            year: snapshot.data.year),
                        _titleWidget(context, 'waterSources', false),
                        WaterComponent(
                            year: snapshot.data.year,
                            data: snapshot.data.waterModelList),
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
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black,
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
    if (filters == null) return;
    viewModel.onFiltersChanged(filters);
  }
}
