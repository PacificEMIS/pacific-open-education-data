import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';

class IndividualExamsFiltersData {
  final int year;
  final String exam;

  const IndividualExamsFiltersData(this.year, this.exam);
}

class IndividualExamsFilters extends StatelessWidget {
  static const kMinHeight = 96.0;
  static const kMaxHeight = 176.0;

  final double _bottomInset;
  final IndividualExamsViewModel _viewModel;

  const IndividualExamsFilters({
    Key key,
    @required double bottomInset,
    @required IndividualExamsViewModel viewModel,
  })  : assert(bottomInset != null),
        assert(viewModel != null),
        _bottomInset = bottomInset,
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IndividualExamsFiltersData>(
      stream: _viewModel.filterViewDataStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return _BottomMenu(
            alwaysVisibleHeight: kMinHeight,
            totalHeight: kMaxHeight,
            bottomInset: _bottomInset,
            children: <Widget>[
              _BottomMenuRow(
                rowName: 'individualSchoolExamsFilterYear'.localized(context),
                name: snapshot.data.year.toString(),
                onPrevTap: _viewModel.onPrevYearFilterPressed,
                onNextTap: _viewModel.onNextYearFilterPressed,
              ),
              _BottomMenuRow(
                rowName: 'individualSchoolExamsFilterType'.localized(context),
                name: snapshot.data.exam,
                onPrevTap: _viewModel.onPrevExamFilterPressed,
                onNextTap: _viewModel.onNextExamFilterPressed,
              ),
            ],
          );
        }
      },
    );
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
          margin: const EdgeInsets.symmetric(horizontal: 8),
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
                fillColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 0.0,
                highlightElevation: 0.0,
                onPressed: _triggerCollapsing,
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
                      child: const Icon(
                        Icons.check,
                        color: AppColors.kTextMinor,
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
                      child: const Icon(
                        Icons.filter_list,
                        color: AppColors.kTextMinor,
                        size: 27.0,
                      ),
                    ),
                  ],
                ),
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
            style: Theme.of(context).textTheme.headline5,
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
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.kTextMinor,
                  size: 21.0,
                ),
              ),
              Expanded(
                child: Text(
                  _name.localized(context),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).accentColor),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FlatButton(
                onPressed: _onNextTap,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.kTextMinor,
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
