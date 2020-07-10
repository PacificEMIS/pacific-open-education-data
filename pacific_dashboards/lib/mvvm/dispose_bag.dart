import 'dart:async';

class DisposeBag {
  bool _isDisposed = false;
  final List<StreamSubscription<dynamic>> _subscriptionsList = [];
  final List<Sink> _sinks = [];

  bool get isDisposed => _isDisposed;

  void addSink(Sink sink) {
    if (_isDisposed) {
      throw 'Already disposed';
    }
    _sinks.add(sink);
  }

  StreamSubscription<T> add<T>(StreamSubscription<T> subscription) {
    if (_isDisposed) {
      throw 'Already disposed';
    }
    _subscriptionsList.add(subscription);
    return subscription;
  }

  void remove(StreamSubscription<dynamic> subscription) {
    subscription.cancel();
    _subscriptionsList.remove(subscription);
  }

  void clear() {
    _subscriptionsList.forEach(
        (StreamSubscription<dynamic> subscription) => subscription.cancel());
    _subscriptionsList.clear();
  }

  void dispose() {
    clear();
    _sinks.forEach((it) => it.close());
    _isDisposed = true;
  }
}

extension DisposeBagStreamExtensions<T> on StreamSubscription<T> {
  void disposeWith(DisposeBag disposeBag) {
    disposeBag.add(this);
  }
}

extension DisposeBagSinkExtensions<T> on Sink<T> {
  void disposeWith(DisposeBag disposeBag) {
    disposeBag.addSink(this);
  }
}