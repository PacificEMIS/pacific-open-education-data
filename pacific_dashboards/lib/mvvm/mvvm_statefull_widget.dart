import 'dart:async';

import 'package:pacific_dashboards/mvvm/mvvm_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_alert_dialog.dart';

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

abstract class MvvmState<VM extends ViewModel, W extends MvvmStatefulWidget>
    extends State<W> {
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
      child: buildWidget(context),
      listener: (ctx, errorMessage) {
        showDialog(
          context: context,
          builder: (context) {
            return PlatformAlertDialog(
              title: AppLocalizations.error,
              message: errorMessage,
            );
          },
        );
      },
    );
  }

  Widget buildWidget(BuildContext context);
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
  _StreamListenerWidgetState<T> createState() =>
      _StreamListenerWidgetState<T>();
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
