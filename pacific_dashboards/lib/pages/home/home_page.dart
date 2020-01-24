import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/home/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/home/sections_grid.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';

class HomePage extends StatefulWidget {
  static const String kRoute = "/";

  @override
  _HomePageState createState() => new _HomePageState();

  HomePage({Key key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: new Container(
        color: Color.fromRGBO(26, 115, 232, 1),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is LoadingHomeState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is LoadedHomeState) {
              return ListView(children: <Widget>[
                Container(
                  height: 80,
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    color: Color.fromRGBO(26, 115, 232, 1),
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.lightBlue,
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _CountrySelectDialog(
                            homeBloc: _homeBloc,
                          );
                        },
                      );
                    },
                    child: Text(
                      AppLocalizations.changeCountry,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.normal,
                          fontFamily: "NotoSans-Regular"),
                    ),
                  ),
                ),
                Container(
                  height: 160,
                  width: 160,
                  child: Image.asset(state.emis.logo),
                ),
                Container(
                  height: 96,
                  width: 266,
                  alignment: Alignment.center,
                  child: Center(
                      child: Text(
                          state.emis == Emis.fedemis
                              ? AppLocalizations
                                  .federatedStateOfMicronesiaSplitted
                              : state.emis.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              fontFamily: "NotoSans",
                              color: Colors.white))),
                ),
                Container(
                    alignment: Alignment.center,
                    child: SectionsGrid(
                      emis: state.emis,
                    ))
              ]);
            }

            throw FallThroughError();
          },
        ),
      ),
    );
  }
}

class _CountrySelectDialog extends StatelessWidget {
  _CountrySelectDialog({@required HomeBloc homeBloc})
      : assert(homeBloc != null),
        _homeBloc = homeBloc;

  final HomeBloc _homeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 244,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(const Radius.circular(8.0))),
        contentPadding: const EdgeInsets.only(top: 10.0, right: 0),
        title: Text(
          AppLocalizations.changeCountry,
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              fontFamily: "NotoSans"),
        ),
        content: Container(
          height: 200,
          width: 280,
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
          child: Column(children: [
            ...Emis.values.map((emis) {
              return _Country(
                emis: emis,
                bloc: _homeBloc,
              );
            }),
          ]),
        ),
      ),
    );
  }
}

class _Country extends StatelessWidget {
  final Emis _emis;
  final HomeBloc _bloc;

  const _Country({
    Key key,
    @required Emis emis,
    @required HomeBloc bloc,
  })  : assert(emis != null),
        assert(bloc != null),
        _emis = emis,
        _bloc = bloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.of(context).pop();
          _bloc.add(EmisChanged(_emis));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              child: Image.asset(_emis.logo, width: 40, height: 40),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child:
                    Text(_emis.name, style: TextStyle(fontFamily: "NotoSans")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
