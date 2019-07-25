import 'package:flutter/material.dart';
import '../resources/Filter.dart';
import '../blocs/FilterBloc.dart';
import '../config/Constants.dart';
import 'FilterWidget.dart';

class FilterPage extends StatefulWidget {
  final List<FilterBloc> blocs;

  FilterPage({Key key, @required this.blocs, }) : super(key: key);

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  @override
  void initState() {
    super.initState();
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
      body: ListView.builder(
      itemCount: widget.blocs.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
          subtitle: FilterWidget(bloc: widget.blocs[index]),
        );
      },
    ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 56,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(Icons.done, color: AppColors.kWhite),
            color: AppColors.kBlue,
            onPressed: () {
              _applyChanges();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Widget> _generateFilters() {
    var filters = List<Widget>();
    widget.blocs.forEach((bloc) {
      filters.add(FilterWidget(bloc: bloc));
    });

    return filters;
  }

  _applyChanges() {
    widget.blocs.forEach((bloc) => bloc.applyChanges());
  }

//  List<Widget> _generateFilterList(AsyncSnapshot<Filter> snapshot) {
//    List<Widget> filterList = List<Widget>.from(snapshot.data.filterTemp.keys.map((String key) {
//      return Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 12.0),
//          child: Card(
//            elevation: 4,
//            child: RadioListTile<String>(
//              title: Text(key),
//              value: key,
//              onChanged: (String value) {
//                setState(() {
//                  widget.bloc.changeSelectedById(value);
//                });
//              },
//              controlAffinity: ListTileControlAffinity.leading,
//              activeColor: AppColors.kBlue,
//              groupValue: widget.bloc.getSelectedKey(),
//            ),
//            borderOnForeground: false,
//          ));
//    }).toList());
//
//    filterList.insert(
//        0,
//        Divider(
//          color: AppColors.kGeyser,
//          height: 1,
//        ));
//
//    filterList.insert(
//      0,
//      Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 12.0),
//        child: Card(
//          elevation: 4,
//          child: RadioListTile<String>(
//            title: Text('Select all'),
//            value: widget.bloc.defaultSelectedKey,
//            onChanged: (String value) {
//              setState(() {
//                widget.bloc.setDefaultFilter();
//              });
//            },
//            controlAffinity: ListTileControlAffinity.leading,
//            activeColor: AppColors.kBlue,
//            groupValue: widget.bloc.getSelectedKey(),
//          ),
//          borderOnForeground: false,
//        ),
//      ),
//    );
//
//    filterList.insert(
//      0,
//      ListTile(
//        title: Text(snapshot.data.filterName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//      ),
//    );
//
//    return filterList;
//  }
}
