import 'package:pacific_dashboards/src/models/teachers_model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class TeachersBloc {
  final _repository = Repository();
  final _teachersFetcher = PublishSubject<TeachersModel>();

  Observable<TeachersModel> get allTeachers => _teachersFetcher.stream;

  fetchAllTeachers() async {
    var model = await _repository.fetchAllTeachers();
    _teachersFetcher.sink.add(model);
  }

  dispose() {
    _teachersFetcher.close();
  }
}

final bloc = TeachersBloc();
