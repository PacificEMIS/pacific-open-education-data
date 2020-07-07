import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/utils/collections.dart';

class FilterPage extends StatefulWidget {
  final List<Filter> _filters;

  const FilterPage({Key key, @required List<Filter> filters})
      : assert(filters != null),
        _filters = filters,
        super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState(_filters);
}

class _FilterPageState extends State<FilterPage> {
  List<Filter> _filters;

  _FilterPageState(this._filters);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _close(context),
        ),
        title: Text(AppLocalizations.filtersTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 100.0),
        children: _createFilterSections(_filters),
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
            color: Theme.of(context).accentColor,
            onPressed: () => _apply(context),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _createFilterSections(List<Filter> filters) {
    final List<Widget> sections = [];

    filters.forEachIndexed((filterIndex, filter) {
      final title = filter.title;
      sections.add(_Title(key: ValueKey('Title $filterIndex'), title: title));

      sections.addAll(filter.items.mapIndexed((itemIndex, item) {
        return _Item(
          key: ValueKey('Item$itemIndex on filter$filterIndex'),
          filter: filter,
          index: itemIndex,
          onChanged: (changedIndex) {
            setState(() {
              _filters[filterIndex].selectedIndex = changedIndex;
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
    Navigator.pop(context, _filters);
  }
}

class _Title extends StatelessWidget {
  final String _title;

  const _Title({
    Key key,
    @required String title,
  })  : assert(title != null),
        _title = title,
        super(key: key);

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
  final Filter _filter;
  final int _index;
  final Function(int index) _onChanged;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: RadioListTile<int>(
        title: Text(
          _filter.items[_index].visibleName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        value: _index,
        groupValue: _filter.selectedIndex,
        onChanged: _onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Theme.of(context).accentColor,
      ),
      borderOnForeground: false,
    );
  }
}
