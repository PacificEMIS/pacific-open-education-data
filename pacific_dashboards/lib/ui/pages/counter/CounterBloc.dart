import 'package:rxdart/rxdart.dart';

class CounterBloc {
  int count = 0;
  BehaviorSubject<int> _subjectCounter;

  CounterBloc() {
    _subjectCounter = BehaviorSubject<int>.seeded(this.count);
  }

  Observable<int> get counterObservable => _subjectCounter.stream;

  void increment() {
    count++;
    _subjectCounter.add(count);
  }

  void decrement() {
    count--;
    _subjectCounter.add(count);
  }

  void dispose() {
    _subjectCounter.close();
  }
}