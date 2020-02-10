import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/exams/bloc/bloc.dart';
import 'package:pacific_dashboards/pages/exams/bloc/exams_navigator.dart';
import 'package:pacific_dashboards/pages/exams/exams_stacked_horizontal_bar_chart.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/module_note.dart';
import 'package:pacific_dashboards/shared_ui/platform_alert_dialog.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';

class ExamsPage extends StatefulWidget {
  static const String kRoute = "/Exams";

  ExamsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExamsPageState();
  }
}

class ExamsPageState extends State<ExamsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamsBloc, ExamsState>(
      listener: (context, state) {
        if (state is ErrorState) {
          _handleErrorState(state, context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.exams),
        ),
        body: BlocBuilder<ExamsBloc, ExamsState>(
          condition: (prevState, currentState) => currentState is BodyState,
          builder: (context, state) {
            if (state is InitialExamsState) {
              return Container();
            }

            if (state is LoadingExamsState) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }

            if (state is PopulatedExamsState) {
              return _PopulatedContent(
                examResults: state.results,
                note: state.note,
              );
            }

            throw FallThroughError();
          },
        ),
        bottomSheet: BlocBuilder<ExamsBloc, ExamsState>(
          condition: (prevState, currentState) => currentState is FilterState,
          builder: (context, state) {
            if (state is InitialExamsState) {
              return Container();
            }

            if (state is PopulatedFilterState) {
              // ignore: close_sinks
              final bloc = BlocProvider.of<ExamsBloc>(context);
              return _BottomMenu(
                alwaysVisibleHeight: 96,
                totalHeight: 256,
                bottomInset: MediaQuery.of(context).viewPadding.bottom,
                children: <Widget>[
                  _BottomMenuRow(
                    rowName: AppLocalizations.exam,
                    name: state.examName,
                    onPrevTap: () => bloc.add(PrevExamSelectedEvent()),
                    onNextTap: () => bloc.add(NextExamSelectedEvent()),
                  ),
                  _BottomMenuRow(
                    rowName: AppLocalizations.view,
                    name: state.viewName,
                    onPrevTap: () => bloc.add(PrevViewSelectedEvent()),
                    onNextTap: () => bloc.add(NextViewSelectedEvent()),
                  ),
                  _BottomMenuRow(
                    rowName: AppLocalizations.filterByStandard,
                    name: state.standardName,
                    onPrevTap: () => bloc.add(PrevFilterSelectedEvent()),
                    onNextTap: () => bloc.add(NextFilterSelectedEvent()),
                  ),
                ],
              );
            }

            throw FallThroughError();
          },
        ),
      ),
    );
  }

  void _handleErrorState(ExamsState state, BuildContext context) {
    if (state is UnknownErrorState) {
      showDialog(
        context: context,
        builder: (buildContext) {
          return PlatformAlertDialog(
            title: AppLocalizations.error,
            message: AppLocalizations.unknownError,
          );
        },
      );
    }
    if (state is ServerUnavailableState) {
      showDialog(
        context: context,
        builder: (buildContext) {
          return PlatformAlertDialog(
            title: AppLocalizations.error,
            message: AppLocalizations.serverUnavailableError,
          );
        },
      );
    }
  }
}

class _PopulatedContent extends StatelessWidget {
  const _PopulatedContent({
    Key key,
    @required BuiltMap<String, BuiltMap<String, Exam>> examResults,
    @required String note,
  })  : assert(examResults != null),
        _examResults = examResults,
        _note = note,
        super(key: key);

  final BuiltMap<String, BuiltMap<String, Exam>> _examResults;
  final String _note;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 260),
      children: <Widget>[
        if (_note != null)
          ModuleNote(
            note: _note,
          ),
        ..._examResults.keys.map((it) {
          final results = _examResults[it];
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  it,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.left,
                  maxLines: 5,
                ),
                ...results.keys.map((it) {
                  final chart =
                      ExamsStackedHorizontalBarChart.fromModel(results[it]);
                  if (it != ExamsNavigator.kNoTitleKey) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Text(
                            it,
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontSize: 12.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        chart,
                      ],
                    );
                  }
                  return chart;
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ],
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
                        color: AppColors.kNevada,
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
                        color: AppColors.kNevada,
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
            style: Theme.of(context).textTheme.headline,
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
                  color: AppColors.kNevada,
                  size: 21.0,
                ),
              ),
              Expanded(
                child: Text(
                  _name,
                  style: Theme.of(context)
                      .textTheme
                      .body2
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
                  color: AppColors.kNevada,
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
