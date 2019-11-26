import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/exam_model.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/pages/exams/exams_bloc.dart';
import 'package:pacific_dashboards/pages/exams/exams_stacked_horizontal_bar_chart.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';

// TODO: refactor
class ExamsPage extends StatefulWidget {
  static const String _kPageName = "Exams";
  final ExamsBloc bloc;

  ExamsPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExamsPageState();
  }
}

class ExamsPageState extends State<ExamsPage> {
  bool _bottomMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  void dispose() {
    debugPrint("disposing");
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kWhite,
      appBar: PlatformAppBar(
        iconTheme: new IconThemeData(color: AppColors.kWhite),
        backgroundColor: AppColors.kRoyalBlue,
        title: Text(
          ExamsPage._kPageName,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<ExamsModel> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                _buildList(snapshot),
              ],
              alignment: Alignment.bottomCenter,
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomSheet: _BottomMenu(
        alwaysVisibleHeight: 96,
        totalHeight: 244,
        bottomInset: MediaQuery.of(context).viewPadding.bottom,
        children: <Widget>[
          _BottomMenuRow(
            rowName: AppLocalizations.exam,
            name: 'name1',
            onPrevTap: () {},
            onNextTap: () {},
          ),
          _BottomMenuRow(
            rowName: AppLocalizations.view,
            name: 'name2',
            onPrevTap: () {},
            onNextTap: () {},
          ),
          _BottomMenuRow(
            rowName: AppLocalizations.filterByStandard,
            name: 'name3name3name3name3name3name3me3name3name3name3name3name3',
            onPrevTap: () {},
            onNextTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<ExamsModel> snapshot) {
    var listItems = snapshot.data.examsDataNavigator.getExamResults();
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          padding:
              EdgeInsets.fromLTRB(16, 16, 16, _bottomMenuExpanded ? 246 : 136),
          itemCount: listItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              subtitle: _generateGridTile(listItems, index),
            );
          },
        );
      },
    );
  }

  Widget _generateGridTile(
      Map<String, Map<String, ExamModel>> data, int index) {
    List<Widget> widgetList = [
      new Text(
        data.keys.toList()[index],
        style: new TextStyle(fontSize: 14.0, color: Colors.black),
        textAlign: TextAlign.left,
        maxLines: 5,
      ),
    ];
    widgetList.addAll(_generateSecondTiles(data[data.keys.toList()[index]]));

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    ));
  }

  List<Widget> _generateSecondTiles(Map<String, ExamModel> data) {
    List<Widget> widgetList = new List<Widget>();
    data.forEach((k, v) {
      if (k != ExamsDataNavigator.kNoTitleKey) {
        widgetList.add(new Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: new Text(
              k,
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            )));
      }
      widgetList.add(ExamsStackedHorizontalBarChart.fromModel(v));
    });
    return widgetList;
  }
}

class _BottomMenu extends StatefulWidget {
  const _BottomMenu({
    Key key,
    @required List<Widget> children,
    @required double alwaysVisibleHeight,
    @required double totalHeight,
    @required double bottomInset,
  })  : assert(children != null),
        assert(alwaysVisibleHeight != null),
        assert(totalHeight != null),
        assert(bottomInset != null),
        _children = children,
        _alwaysVisibleHeight = alwaysVisibleHeight,
        _totalHeight = totalHeight,
        _bottomInset = bottomInset,
        super(key: key);

  final List<Widget> _children;
  final double _alwaysVisibleHeight;
  final double _totalHeight;
  final double _bottomInset;

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<_BottomMenu>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _insetAnimation;
  Animation<double> _heightAnimation;
  Animation<double> _iconOpacityAnimation;
  Animation<double> _iconRotationAnimation;
  bool _isCollapsed = true;

  @override
  void initState() {
    super.initState();
    _configureAnimations();
  }

  void _configureAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _insetAnimation = Tween<double>(begin: widget._bottomInset, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5),
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _isCollapsed = true;
        }
      });

    _heightAnimation = Tween<double>(
      begin: 0,
      end: widget._totalHeight - widget._alwaysVisibleHeight,
    ).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isCollapsed = false;
        }
      });

    _iconOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _iconRotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const buttonSize = 50.0;
    const blurRadius = 10.0;
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          height: widget._alwaysVisibleHeight +
              _heightAnimation.value +
              widget._bottomInset,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        );
      },
      child: Stack(
        overflow: Overflow.clip,
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: blurRadius,
                ),
              ],
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: blurRadius,
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget._children.length > 0) widget._children[0],
                  if (widget._children.length > 1)
                    AnimatedBuilder(
                      animation: _insetAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: _insetAnimation.value,
                        );
                      },
                    ),
                  ...widget._children.sublist(1),
                  if (widget._bottomInset > 0)
                    Container(
                      width: double.infinity,
                      height: widget._bottomInset,
                    ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _iconRotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _iconRotationAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: buttonSize,
              height: buttonSize,
              child: RawMaterialButton(
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _iconOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _iconOpacityAnimation.value,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.check,
                        color: AppColors.kExamsTableTextGray,
                        size: 27.0,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _iconOpacityAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: 1 - _iconOpacityAnimation.value,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.filter_list,
                        color: AppColors.kExamsTableTextGray,
                        size: 27.0,
                      ),
                    ),
                  ],
                ),
                fillColor: Colors.white,
                shape: CircleBorder(),
                elevation: 0.0,
                highlightElevation: 0.0,
                onPressed: _triggerCollapsing,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerCollapsing() {
    if (!_animationController.isAnimating) {
      if (_isCollapsed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
}

class _BottomMenuRow extends StatelessWidget {
  const _BottomMenuRow({
    Key key,
    @required String rowName,
    @required String name,
    @required VoidCallback onPrevTap,
    @required VoidCallback onNextTap,
  })  : assert(rowName != null),
        assert(name != null),
        assert(onPrevTap != null),
        assert(onNextTap != null),
        _rowName = rowName,
        _name = name,
        _onPrevTap = onPrevTap,
        _onNextTap = onNextTap,
        super(key: key);

  final VoidCallback _onPrevTap;
  final VoidCallback _onNextTap;
  final String _rowName;
  final String _name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(
            _rowName,
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        ButtonTheme(
          minWidth: 50,
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: _onPrevTap,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.kExamsTableTextGray,
                  size: 21.0,
                ),
              ),
              Expanded(
                child: Text(
                  _name,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kDenim,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FlatButton(
                onPressed: _onNextTap,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.kExamsTableTextGray,
                  size: 21.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
