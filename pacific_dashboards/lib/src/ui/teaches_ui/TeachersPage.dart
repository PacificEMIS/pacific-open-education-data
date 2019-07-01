import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import '../../blocs/TeachersBloc.dart';
import '../../utils/HexColor.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartsGridWidget.dart';

class TeachersPage extends StatefulWidget {
  final TeachersBloc bloc;

  TeachersPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeachersPageState();
  }
}

class TeachersPageState extends State<TeachersPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teachers"),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<TeachersModel> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildList(snapshot),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<TeachersModel> snapshot) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          itemCount: 5,
          //listDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _getTilesAmountInRowByScreenSize(orientation)),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              subtitle: _generateGridTile(snapshot.data, index),
            );
          },
        );
      },
    );
  }

  int _getTilesAmountInRowByScreenSize(Orientation orientation) {
    var isLandscape = orientation == Orientation.landscape;
    var screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    if (isLandscape) {
      if (screenWidth > 700) {
        return 3;
      }

      return 2;
    } else {
      if (screenWidth > 600) {
        return 2;
      }

      return 1;
    }
  }

  Widget _generateGridTile(TeachersModel data, int index) {
    switch (index) {
      case 0:
        return BaseTileWidget(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Teachers by Authority",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: "Noto Sans",
                    letterSpacing: 0.25,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                InkResponse(
                  child: Icon(
                    Icons.tune,
                    color: HexColor("#132826"),
                  ),
                  onTap: () => {},
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(data.getSortedByState()),
                Table(
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Text(
                        'State',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Teachers',
                        textAlign: TextAlign.end,
                      ),
                    ]),
                  ],
                ),
              ],
            ));
        break;
      case 1:
        return ChartFactory.getPieChartViewByData(data.getSortedByGovt());
        break;
      default:
        return ChartFactory.getPieChartViewByData(data.getSortedByAuthority());
    }
  }

  Widget _generateTable() {}
//
//      BaseTileWidget(
//        title: Padding(
//          padding: const EdgeInsets.all(16.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                "Teachers by Authority",
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 16.0,
//                  fontFamily: "Noto Sans",
//                  letterSpacing: 0.25,
//                  fontStyle: FontStyle.normal,
//                ),
//              ),
//              InkResponse(
//                child: Icon(
//                  Icons.tune,
//                  color: HexColor("#132826"),
//                ),
//                onTap: () => {},
//              ),
//            ],
//          ),
//        ),
//        body: Text("Label"),
////        body: ListView(
////          children: <Widget>[],
////        ),
//      ),
////      ChartsGridWidget(
////        bloc: bloc,
////      ),
//    );
//  }
}
