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
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _applyChanges() {
    widget.blocs.forEach((bloc) => bloc.applyChanges());
  }
}
