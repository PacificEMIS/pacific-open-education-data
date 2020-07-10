import 'package:flutter/material.dart';
import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

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
          viewModelBuilder: (ctx) => ViewModelFactory.instance.home,
        );
}

class _HomePageState extends MvvmState<HomeViewModel, HomePage> {
  @override
  Widget buildWidget(BuildContext context) {
    return StreamListenerWidget(
      stream: viewModel.activityIndicatorStream,
      predicate: (isLoading) => isLoading,
      listener: (ctx, _) {},
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView(
          children: <Widget>[
            Container(
              height: 80,
              alignment: Alignment.centerRight,
              child: FlatButton(
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
                child: Text(
                  AppLocalizations.changeCountry,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            CurrentEmisWidget(viewModel: viewModel),
            StreamBuilder<List<Section>>(
              stream: viewModel.sectionStream,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    child: SectionsGrid(
                      sections: snapshot.data,
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
