import 'package:flutter/material.dart';
import '../resources/Filter.dart';
import '../blocs/FilterBloc.dart';
import '../config/Constants.dart';

class FilterWidget extends StatefulWidget {
  final FilterBloc bloc;

  FilterWidget({Key key, @required this.bloc}) : super(key: key);

  @override
  FilterWidgetState createState() => new FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: AppColors.kWhite,
          ),
          title: new Text('Filter', style: TextStyle(color: AppColors.kWhite)),
          backgroundColor: AppColors.kBlue),
      body: StreamBuilder(
          stream: widget.bloc.data,
          builder: (context, AsyncSnapshot<Filter> snapshot) {
            if (snapshot.hasData) {
              return new ListView(
                children: generateFilterList(snapshot),
              );
            } else {
              return Text('');
            }
          }),
      floatingActionButton: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new SizedBox(
          width: double.infinity,
          height: 56,
          child: new FlatButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            ),
            child: Text('APPLY',
                style: TextStyle(color: AppColors.kWhite, fontSize: 20)),
            color: AppColors.kBlue,
            onPressed: () {
              widget.bloc.applyChanges();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Widget> generateFilterList(AsyncSnapshot<Filter> snapshot) {
    List<Widget> filterList =
        List<Widget>.from(snapshot.data.filterTemp.keys.map((String key) {
      return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Card(
            elevation: 4,
            child: CheckboxListTile(
              title: new Text(key),
              value: snapshot.data.filterTemp[key],
              onChanged: (bool value) {
                widget.bloc.changeOne(key, value);
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.kBlue,
            ),
            borderOnForeground: false,
          ));
    }).toList());

    filterList.insert(
        0,
        Divider(
          color: AppColors.kGeyser,
          height: 1,
        ));

    filterList.insert(
      0,
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new CheckboxListTile(
          title: new Text('Select all'),
          value: !snapshot.data.filterTemp.containsValue(false),
          onChanged: (bool value) {
            widget.bloc.changeAll(value);
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.kBlue,
        ),
      ),
    );

    filterList.insert(
        0,
        new ListTile(
          title: Text(snapshot.data.filterName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ));

    return filterList;
  }
}
