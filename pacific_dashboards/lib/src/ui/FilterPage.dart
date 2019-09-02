import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/blocs/FilterBloc.dart';
import 'package:pacific_dashboards/src/config/Constants.dart';
import 'package:pacific_dashboards/src/ui/FilterWidget.dart';

class FilterPage extends StatefulWidget {
  final List<FilterBloc> blocs;

  FilterPage({
    Key key,
    @required this.blocs,
  }) : super(key: key);

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
          iconTheme: IconThemeData(
            color: AppColors.kWhite,
          ),
          title: Text('Filter', style: TextStyle(color: AppColors.kWhite)),
          backgroundColor: AppColors.kRoyalBlue),
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
          width: 56,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Icon(Icons.done, color: AppColors.kWhite),
            color: AppColors.kRoyalBlue,
            onPressed: () {
              _applyChanges();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _applyChanges() {
    widget.blocs.forEach((bloc) => bloc.applyChanges());
  }
}
