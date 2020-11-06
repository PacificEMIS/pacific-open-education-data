import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';

import 'indicators_filter_data.dart';

class IndicatorsFiltersPage extends StatefulWidget {
  static const String kRoute = "/Indicators/Filters";
  final IndicatorsFilterData filtersData;
  int selectFirstYear;
  int selectSecondYear;
  List<int> canSelectYears;
  List<String> regions;
  String regionName;


  IndicatorsFiltersPage({Key key, this.filtersData, this.canSelectYears,this.regions, this.regionName})
      : super(
    key: key,
  );

  @override
  State<StatefulWidget> createState() {
    selectFirstYear = int.parse(filtersData.firstYear);
    selectSecondYear = int.parse(filtersData.secondYear);
    regionName = filtersData.region;
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
                .primaryColor,
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
              DropdownButton<int>(
                value: widget.selectFirstYear,
                items: widget.canSelectYears.map((
                    int value) {
                  return new DropdownMenuItem<int>(
                    value: value,
                    child: new Text(
                      value.toString(),
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 18),),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    widget.selectFirstYear = newValue;
                    if (widget.selectSecondYear <= widget.selectFirstYear) {
                      widget.selectSecondYear = widget.selectFirstYear + 1;
                      if (!widget.canSelectYears.contains(
                          widget.selectSecondYear)) {
                        widget.selectSecondYear = widget.selectFirstYear;
                      }
                    }
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
              DropdownButton<int>(
                value: widget.selectSecondYear,
                items: widget.canSelectYears.map((
                    int value) {
                  return new DropdownMenuItem<int>(
                    value: value,
                    child: new Text(
                      value.toString(),
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 18),),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    widget.selectSecondYear = newValue;
                    if (widget.selectSecondYear <= widget.selectFirstYear) {
                      widget.selectFirstYear = widget.selectSecondYear - 1;
                      if (!widget.canSelectYears.contains(
                          widget.selectFirstYear)) {
                        widget.selectFirstYear = widget.selectSecondYear;
                      }
                    }
                  });
                },
              ),
              //Temp fix
              Strings.emis == Emis.fedemis ? Text(
                'filtersByState'.localized(context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ) : Container(),
              Strings.emis == Emis.fedemis ?  DropdownButton<String>(
                value: widget.regionName,
                items: widget.regions.map((
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
                    widget.regionName = newValue;
                  });
                },
              ) : Container(),
            ]
        ),
      ),
    );
  }

  void _apply(BuildContext context) {
    var result = [widget.selectFirstYear.toString(), widget.selectSecondYear.toString(), widget.regionName];
    Navigator.pop(context, result);
  }
}
