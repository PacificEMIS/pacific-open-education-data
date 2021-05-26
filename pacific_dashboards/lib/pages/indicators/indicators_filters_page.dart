import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';

import 'indicators_filter_data.dart';

class IndicatorsFiltersPage extends StatefulWidget {
  static const String kRoute = "/Indicators/Filters";
  final IndicatorsFilterData filtersData;
  String selectFirstYear;
  String selectSecondYear;
  List<String> canSelectYears;

  IndicatorsFiltersPage({Key key, this.filtersData, this.canSelectYears})
      : super(
    key: key,
  );

  @override
  State<StatefulWidget> createState() {
    selectFirstYear = filtersData.firstYear;
    selectSecondYear = filtersData.secondYear;
    return IndicatorsFiltersPageState();
  }
}

class IndicatorsFiltersPageState extends State<IndicatorsFiltersPage> {

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery
        .of(context)
        .padding
        .bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        title: Text('filtersTitle'.localized(context)),
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
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            color: Theme
                .of(context)
                .accentColor,
            onPressed: () => _apply(context),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'indicatorsFirstYear'.localized(context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                value: widget.selectFirstYear,
                items: widget.canSelectYears.map((
                    String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 18),),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    widget.selectFirstYear = newValue;
                  });
                },
              ),
              Text(
                'indicatorsSecondYear'.localized(context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 20),
                textAlign: TextAlign.left,
                strutStyle: StrutStyle(height: 3),
              ),
              DropdownButton<String>(
                value: widget.selectSecondYear,
                items: widget.canSelectYears.map((
                    String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 18),),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    widget.selectSecondYear = newValue;
                  });
                },
              ),
            ]
        ),
      ),
    );
  }

  void _apply(BuildContext context) {
    var result = new Pair(widget.selectFirstYear, widget.selectSecondYear);
    Navigator.pop(context, result);
  }
}
