import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

typedef TabbedWidgetBuilder<T> = Widget Function(BuildContext context, T tab);
typedef TabNameBuilder<T> = String Function(T tab);

class MiniTabLayout<T> extends StatefulWidget {
  final List<T> tabs;
  final TabbedWidgetBuilder<T> builder;
  final TabNameBuilder<T> tabNameBuilder;
  final double padding;
  const MiniTabLayout({
    Key key,
    @required this.tabs,
    @required this.tabNameBuilder,
    @required this.builder, this.padding,
  })  : assert(tabs != null),
        assert(tabNameBuilder != null),
        assert(builder != null),
        super(key: key);

  @override
  _MiniTabLayoutState<T> createState() => _MiniTabLayoutState<T>();
}

class _MiniTabLayoutState<T> extends State<MiniTabLayout> {

  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final defaultPadding = widget.padding ?? 16.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.tabs.mapIndexed((index, tab) {
                return InkWell(
                  onTap: () {
                    if (_selectedIndex != index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    child: Text(
                      widget.tabNameBuilder(tab),
                      style: _selectedIndex == index
                          ? textTheme.miniTabSelected
                          : textTheme.miniTab,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            height: 1,
            color: AppColors.kGeyser,
          ),
          SizedBox(
            height: 8,
          ),
          widget.builder(context, _tabCheckingIndexes),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  T get _tabCheckingIndexes {
    if (_selectedIndex >= widget.tabs.length) {
      _selectedIndex = 0;
      setState(() {
        _selectedIndex = 0;
      });
    }
    return widget.tabs[_selectedIndex];
  }
}
