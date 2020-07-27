import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

typedef TabbedWidgetBuilder<T> = Widget Function(BuildContext context, T tab);
typedef TabNameBuilder<T> = String Function(T tab);

class MiniTabLayout<T> extends StatefulWidget {
  final List<T> tabs;
  final TabbedWidgetBuilder<T> builder;
  final TabNameBuilder<T> tabNameBuilder;

  const MiniTabLayout({
    Key key,
    @required this.tabs,
    @required this.tabNameBuilder,
    @required this.builder,
  })  : assert(tabs != null),
        assert(tabNameBuilder != null),
        assert(builder != null),
        super(key: key);

  @override
  _MiniTabLayoutState<T> createState() => _MiniTabLayoutState<T>();
}

class _MiniTabLayoutState<T> extends State<MiniTabLayout> {
  T _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.tabs.first;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              children: widget.tabs.map((tab) {
                return InkWell(
                  onTap: () {
                    if (_selectedTab != tab) {
                      setState(() {
                        _selectedTab = tab;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    child: Text(
                      widget.tabNameBuilder(tab),
                      style: _selectedTab == tab
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
          widget.builder(context, _selectedTab),
        ],
      ),
    );
  }
}
