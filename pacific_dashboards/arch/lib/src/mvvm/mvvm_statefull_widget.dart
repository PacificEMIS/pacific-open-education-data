import 'dart:async';
import 'dart:io';

import 'package:arch/src/mvvm/mvvm_view_model.dart';
import 'package:arch/src/utils/error_listener.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ViewModelBuilder = ViewModel Function(BuildContext);
typedef StreamFilterPredicate<T> = bool Function(T);
typedef StreamListener<T> = void Function(BuildContext, T);

abstract class MvvmStatefulWidget extends StatefulWidget {
  final ViewModelBuilder viewModelBuilder;

  const MvvmStatefulWidget({
    Key key,
    @required this.viewModelBuilder,
  })  : assert(viewModelBuilder != null),
        super(key: key);
}

abstract class MvvmState<VM extends ViewModel, W extends MvvmStatefulWidget> extends State<W> {
  int _blockingLoaderCounter = 0;

  @protected
  VM viewModel;

  /// Descendants must call super first
  @mustCallSuper
  @override
  void initState() {
    viewModel = widget.viewModelBuilder(context);
    super.initState();
    viewModel.onInit();
  }

  /// Descendants must call super in the end
  @protected
  @mustCallSuper
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamListenerWidget(
      stream: viewModel.errorMessagesStream,
      listener: (ctx, message) {
        _hideBlockingProgress(context, force: true);
        defaultErrorListener.handleErrorMessage(ctx, message);
      },
      child: StreamListenerWidget(
        stream: viewModel.needToShowBlockingLoadingStream,
        listener: (context, needToShowBlockingLoading) {
          if (needToShowBlockingLoading) {
            _showBlockingProgress(context);
          } else {
            _hideBlockingProgress(context);
          }
        },
        child: buildWidget(context),
      ),
    );
  }

  Widget buildWidget(BuildContext context);

  void _hideBlockingProgress(
    BuildContext context, {
    bool force = false,
  }) {
    if (force && _blockingLoaderCounter > 0) {
      _blockingLoaderCounter = 1;
    }
    if (_blockingLoaderCounter > 0) {
      _blockingLoaderCounter--;
      if (_blockingLoaderCounter == 0) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  void _showBlockingProgress(BuildContext context) {
    _blockingLoaderCounter++;
    if (_blockingLoaderCounter > 1) {
      return;
    }
    if (Platform.isIOS) {
      cupertino.showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (context) {
          return cupertino.WillPopScope(
            onWillPop: () async => false,
            child: cupertino.Center(
              child: cupertino.Container(
                width: 128,
                height: 128,
                child: cupertino.CupertinoPopupSurface(
                  isSurfacePainted: true,
                  child: cupertino.Center(
                    child: cupertino.CupertinoActivityIndicator(
                      radius: 37,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              contentPadding: const EdgeInsets.all(0),
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

class StreamListenerWidget<T> extends StatefulWidget {
  final Stream<T> _stream;
  final StreamFilterPredicate<T> _predicate;
  final StreamListener<T> _listener;
  final Widget _child;

  const StreamListenerWidget({
    Key key,
    @required Stream<T> stream,
    @required Widget child,
    @required StreamListener<T> listener,
    StreamFilterPredicate<T> predicate,
  })  : assert(child != null),
        assert(stream != null),
        assert(listener != null),
        _child = child,
        _stream = stream,
        _predicate = predicate,
        _listener = listener,
        super(key: key);

  @override
  _StreamListenerWidgetState<T> createState() => _StreamListenerWidgetState<T>();
}

class _StreamListenerWidgetState<T> extends State<StreamListenerWidget> {
  StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => widget._child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (_subscription == null) {
      _subscription = widget._stream.listen((event) {
        if (widget._predicate?.call(event) ?? true) {
          widget._listener(context, event);
        }
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
