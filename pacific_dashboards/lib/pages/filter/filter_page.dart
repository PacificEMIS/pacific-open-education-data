import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/res/strings.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key key, @required List<Filter> filters})
      : assert(filters != null),
        _filters = filters,
        super(key: key);

  final List<Filter> _filters;

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _close(context),
        ),
        title: Text('filtersTitle'.localized(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 100.0),
        children: _createFilterSections(context, widget._filters),
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
            color: Theme.of(context).accentColor,
            onPressed: () => _apply(context),
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _createFilterSections(
      BuildContext context, List<Filter> filters) {
    final sections = <Widget>[];

    filters.forEachIndexed((filterIndex, filter) {
      final title = filter.title.localized(context);
      sections
        ..add(_Title(key: ValueKey('Title $filterIndex'), title: title))
        ..addAll(filter.items.mapIndexed((itemIndex, item) {
          return _Item(
            key: ValueKey('Item$itemIndex on filter$filterIndex'),
            filter: filter,
            index: itemIndex,
            onChanged: (changedIndex) {
              setState(() {
                widget._filters[filterIndex].selectedIndex = changedIndex;
              });
            },
          );
        }));
    });

    return sections;
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }

  void _apply(BuildContext context) {
    Navigator.pop(context, widget._filters);
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key key,
    @required String title,
  })  : assert(title != null),
        _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
      child: Text(
        _title,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key key,
    @required Filter filter,
    @required int index,
    @required Function(int index) onChanged,
  })  : assert(filter != null),
        assert(index != null),
        assert(onChanged != null),
        _filter = filter,
        _index = index,
        _onChanged = onChanged,
        super(key: key);

  final Filter _filter;
  final int _index;
  final Function(int index) _onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      borderOnForeground: false,
      child: RadioListTile<int>(
        title: Text(
          _filter.items[_index].visibleName.localized(context),
          style: Theme.of(context).textTheme.subtitle1,
        ),
        value: _index,
        groupValue: _filter.selectedIndex,
        onChanged: _onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Theme.of(context).accentColor,
      ),
    );
  }
}
