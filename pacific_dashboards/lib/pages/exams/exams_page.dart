import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/pages/exams/exams_bloc.dart';
import 'package:pacific_dashboards/pages/exams/exams_stacked_horizontal_bar_chart.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';

// TODO: refactor
class ExamsPage extends StatefulWidget {
  static const String _kPageName = "Exams";
  final ExamsBloc bloc;

  ExamsPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExamsPageState();
  }
}

class ExamsPageState extends State<ExamsPage> {
  bool _bottomMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  void dispose() {
    debugPrint("disposing");
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: AppColors.kWhite,
        appBar: PlatformAppBar(
          iconTheme: new IconThemeData(color: AppColors.kWhite),
          backgroundColor: AppColors.kRoyalBlue,
          title: Text(
            ExamsPage._kPageName,
            style: TextStyle(
              color: AppColors.kWhite,
              fontSize: 18.0,
              fontFamily: "Noto Sans",
            ),
          ),
        ),
        body: StreamBuilder(
          stream: widget.bloc.data,
          builder: (context, AsyncSnapshot<ExamsModel> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [_buildList(snapshot), ..._buildBottomMenu(snapshot)],
                alignment: Alignment.bottomCenter,
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _buildList(AsyncSnapshot<ExamsModel> snapshot) {
    var listItems = snapshot.data.examsDataNavigator.getExamResults();
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          padding:
              EdgeInsets.fromLTRB(16, 16, 16, _bottomMenuExpanded ? 246 : 136),
          itemCount: listItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              subtitle: _generateGridTile(listItems, index),
            );
          },
        );
      },
    );
  }

  Widget _generateGridTile(
      Map<String, Map<String, ExamModel>> data, int index) {
    List<Widget> widgetList = [
      new Text(
        data.keys.toList()[index],
        style: new TextStyle(fontSize: 14.0, color: Colors.black),
        textAlign: TextAlign.left,
        maxLines: 5,
      ),
    ];
    widgetList.addAll(_generateSecondTiles(data[data.keys.toList()[index]]));

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    ));
  }

  List<Widget> _generateSecondTiles(Map<String, ExamModel> data) {
    List<Widget> widgetList = new List<Widget>();
    data.forEach((k, v) {
      if (k != ExamsDataNavigator.kNoTitleKey) {
        widgetList.add(new Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: new Text(
              k,
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            )));
      }
      widgetList.add(ExamsStackedHorizontalBarChart.fromModel(v));
    });
    return widgetList;
  }

  List<Widget> _buildBottomMenu(AsyncSnapshot<ExamsModel> snapshot) {
    double size = _bottomMenuExpanded ? 240 : 77;
    double buttonSize = 50;

    List<Widget> rows = new List<Widget>();
    rows += _bottomMenuRow(
        snapshot.data.examsDataNavigator.prevExamPage,
        snapshot.data.examsDataNavigator.nextExamPage,
        AppLocalizations.exam,
        snapshot.data.examsDataNavigator.getExamPageName());
    if (_bottomMenuExpanded) {
      rows += _bottomMenuRow(
          snapshot.data.examsDataNavigator.prevExamView,
          snapshot.data.examsDataNavigator.nextExamView,
          AppLocalizations.view,
          snapshot.data.examsDataNavigator.getExamViewName());
      rows += _bottomMenuRow(
          snapshot.data.examsDataNavigator.prevExamStandard,
          snapshot.data.examsDataNavigator.nextExamStandard,
          AppLocalizations.filterByStandard,
          snapshot.data.examsDataNavigator.getStandardName());
    }
    return [
      new Positioned(
          bottom: size - buttonSize / 1.5,
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius:
                  new BorderRadius.all(Radius.circular(buttonSize / 2)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                ),
              ],
            ),
            height: buttonSize,
            width: buttonSize,
          )),
      new Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              height: size,
              width: double.infinity,
              margin: new EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rows,
              ))),
      new Positioned(
          bottom: size - buttonSize / 1.5, child: _bottomMenuButton(buttonSize))
    ];
  }

  Widget _bottomMenuButton(double buttonSize) {
    var openIcon = new Icon(
      Icons.check,
      color: AppColors.kExamsTableTextGray,
      size: 27.0,
    );
    var closedIcon = new Icon(
      Icons.filter_list,
      color: AppColors.kExamsTableTextGray,
      size: 27.0,
    );

    return new Align(
        alignment: Alignment.bottomCenter,
        child: new Container(
            width: buttonSize,
            height: buttonSize,
            child: new RawMaterialButton(
                child: _bottomMenuExpanded ? openIcon : closedIcon,
                fillColor: Colors.white,
                shape: new CircleBorder(),
                elevation: 0.0,
                highlightElevation: 0.0,
                onPressed: () {
                  setState(() {
                    _bottomMenuExpanded = !_bottomMenuExpanded;
                  });
                })));
  }

  List<Widget> _bottomMenuRow(
      VoidCallback back, VoidCallback next, String rowName, String name) {
    double fontSize = 14;
    if (name.length > 20) {
      fontSize -= (name.length - 20) / 10;
    }
    return [
      new Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
          child: new Text(
            rowName,
            style: new TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          )),
      new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ButtonTheme(
            minWidth: 50,
            height: 40,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  back();
                });
              },
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: new Icon(
                Icons.chevron_left,
                color: AppColors.kExamsTableTextGray,
                size: 21.0,
              ),
            )),
        Expanded(
          child: new Text(
            name,
            style: new TextStyle(
                fontSize: fontSize,
                color: AppColors.kDenim,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        ButtonTheme(
            minWidth: 50,
            height: 40,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  next();
                });
              },
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: new Icon(
                Icons.chevron_right,
                color: AppColors.kExamsTableTextGray,
                size: 21.0,
              ),
            )),
      ])
    ];
  }
}
