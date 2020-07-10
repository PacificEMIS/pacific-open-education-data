import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsListViewModel extends ViewModel {

  final Subject _schoolsSubject = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get schoolsStream => _schoolsSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _schoolsSubject.disposeWith(disposeBag);
  }

}

