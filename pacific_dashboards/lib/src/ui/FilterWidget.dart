import 'package:flutter/material.dart';
import '../resources/Filter.dart';
import '../blocs/FilterBloc.dart';
import '../config/Constants.dart';

class FilterPage extends StatefulWidget {
  final FilterBloc bloc;

  FilterPage({Key key, @required this.bloc}) : super(key: key);

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.kWhite,
          ),
          title: Text('Filter', style: TextStyle(color: AppColors.kWhite)),
          backgroundColor: AppColors.kBlue),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<Filter> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _generateFilterList(snapshot),
            );
          } else {
            return Text('');
          }
        },
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text('APPLY', style: TextStyle(color: AppColors.kWhite, fontSize: 20)),
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

  List<Widget> _generateFilterList(AsyncSnapshot<Filter> snapshot) {
    List<Widget> filterList = List<Widget>.from(snapshot.data.filterTemp.keys.map((String key) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Card(
            elevation: 4,
            child: RadioListTile<String>(
              title: Text(key),
              value: key,
              onChanged: (String value) {
                setState(() {
                  widget.bloc.changeSelectedById(value);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.kBlue,
              groupValue: widget.bloc.getSelectedKey(),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          elevation: 4,
          child: RadioListTile<String>(
            title: Text('Select all'),
            value: 'Select all',
            onChanged: (String value) {
              setState(() {
                widget.bloc.changeAll(value);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.kBlue,
            groupValue: widget.bloc.getSelectedKey(),
          ),
          borderOnForeground: false,
        ),
      ),
    );

    filterList.insert(
      0,
      ListTile(
        title: Text(snapshot.data.filterName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );

    return filterList;
  }
}
