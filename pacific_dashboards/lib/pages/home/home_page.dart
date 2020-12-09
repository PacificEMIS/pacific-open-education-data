import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/view_model_factory.dart';
import 'package:pacific_dashboards/pages/home/components/country_select_dialog_widget.dart';
import 'package:pacific_dashboards/pages/home/components/current_emis_widget.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/home/components/sections_grid.dart';

class HomePage extends MvvmStatefulWidget {
  HomePage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createHomeViewModel(ctx),
        );

  static const String kRoute = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends MvvmState<HomeViewModel, HomePage> {
  @override
  Widget buildWidget(BuildContext context) {
    final useMobileLayout = MediaQuery.of(context).size.shortestSide < 720;
    return StreamListenerWidget(
      stream: viewModel.activityIndicatorStream,
      predicate: (isLoading) => isLoading,
      listener: (ctx, _) {},
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: const EdgeInsets.all(8.0),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CountrySelectDialog(
                        viewModel: viewModel,
                      );
                    },
                  );
                },
                child: Text(
                  'homeChangeCountryButton'.localized(context),
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            CurrentEmisWidget(
              viewModel: viewModel,
              useMobileLayout: useMobileLayout,
            ),
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
      ),
    );
  }
}
