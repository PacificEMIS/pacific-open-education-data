import 'package:flutter/material.dart';
import '../resources/Filter.dart';

class FilterWidget extends StatefulWidget {
  final Filter data;
  Map<String, bool> _tempFilter;

  FilterWidget({Key key, @required this.data}) : super(key: key);

  @override
  FilterWidgetState createState() => new FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  @override
  void initState() {
    super.initState();
    widget._tempFilter = new Map<String, bool>();
    widget._tempFilter.addAll(widget.data.getFilter());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text('Filter', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1A73E8)),
      body: new ListView(
        children: generateFilterList(),
      ),
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
                style: TextStyle(color: Colors.white, fontSize: 20)),
            color: Color(0xFF1A73E8),
            onPressed: () {
              widget.data.setFilter(widget._tempFilter);
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Widget> generateFilterList() {
    List<Widget> filterList =
        List<Widget>.from(widget._tempFilter.keys.map((String key) {
      return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Card(
            elevation: 4,
            child: CheckboxListTile(
              title: new Text(key),
              value: widget._tempFilter[key],
              onChanged: (bool value) {
                setState(() {
                  widget._tempFilter[key] = value;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.blue[700],
            ),
            borderOnForeground: false,
          ));
    }).toList());

    filterList.insert(
        0,
        Divider(
          color: Colors.grey,
          height: 1,
        ));

    filterList.insert(
      0,
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new CheckboxListTile(
          title: new Text('Select all'),
          value: !widget._tempFilter.containsValue(false),
          onChanged: (bool value) {
            setState(() {
              widget._tempFilter
                  .forEach((k, v) => widget._tempFilter[k] = value);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.blue[700],
        ),
      ),
    );

    filterList.insert(
        0,
        new ListTile(
          title: Text(widget.data.filterName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ));

    return filterList;
  }
}
