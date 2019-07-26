import 'package:flutter/material.dart';
import '../resources/Filter.dart';
import '../blocs/FilterBloc.dart';
import '../config/Constants.dart';

class FilterWidget extends StatefulWidget {
  final FilterBloc bloc;

  FilterWidget({Key key, @required this.bloc}) : super(key: key);

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.initialize();
    return StreamBuilder(
      stream: widget.bloc.data,
      builder: (context, AsyncSnapshot<Filter> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: _generateFilterList(snapshot),
          );
        } else {
          return Text('');
        }
      },
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
            groupValue: widget.bloc.selectedKey,
          ),
          borderOnForeground: false,
        ),
      );
    }).toList());

    if (!widget.bloc.filter.getFilter().containsKey(widget.bloc.defaultSelectedKey)) {
      filterList.insert(
        0,
        Divider(
          color: AppColors.kGeyser,
          height: 1,
        ),
      );

      filterList.insert(
        0,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Card(
            elevation: 4,
            child: RadioListTile<String>(
              title: Text(widget.bloc.defaultSelectedKey),
              value: widget.bloc.defaultSelectedKey,
              onChanged: (String value) {
                setState(() {
                  widget.bloc.setDefaultFilter();
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.kBlue,
              groupValue: widget.bloc.selectedKey,
            ),
            borderOnForeground: false,
          ),
        ),
      );
    }

    filterList.insert(
      0,
      ListTile(
        title: Text(snapshot.data.filterName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );

    return filterList;
  }
}
