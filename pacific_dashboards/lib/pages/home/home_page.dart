import 'dart:io';

import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/view_model_factory.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/country_select_dialog_widget.dart';
import 'components/current_emis_widget.dart';
import 'components/section.dart';
import 'components/sections_grid.dart';

class HomePage extends MvvmStatefulWidget {
  static const String kRoute = "/";

  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createHomeViewModel(ctx),
        );
}

class _HomePageState extends MvvmState<HomeViewModel, HomePage> {
  @override
  Widget buildWidget(BuildContext context) {
    var useMobileLayout = MediaQuery
        .of(context)
        .size
        .shortestSide < 720;
    return StreamListenerWidget(
        stream: viewModel.activityIndicatorStream,
        predicate: (isLoading) => isLoading,
        listener: (ctx, _) {},
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<bool>(
                    stream: viewModel.showUpdateNoticeStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data) {
                        return Container();
                      }
                      return InkWell(child: Container(
                        color: Colors.red,
                        margin: EdgeInsets.only(top: 32),
                        child: Text(
                          'appIsOutdated'.localized(context),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4,
                        ),
                      ),
                          onTap: () =>
                              launch(
                                  Platform.isIOS
                                      ?
                                  'https://apps.apple.com/us/app/pacific-open-education-data/id1487072947?app=itunes&ign-mpt=uo%3D4'
                                      :
                                  'https://play.google.com/store/apps/details?id=org.pacific_emis.opendata&hl=en_US&gl=US')
                      );
                    },
                  ),

                  Flexible(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(8.0),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CountrySelectDialog(
                                    viewModel: viewModel,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        CurrentEmisWidget(
                          viewModel: viewModel,
                          useMobileLayout: useMobileLayout,
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder<List<Section>>(
                          stream: viewModel.sectionStream,
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                alignment: Alignment.center,
                                child: SectionsGrid(
                                  sections: snapshot.data,
                                  useMobileLayout: useMobileLayout,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
}
