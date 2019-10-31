import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/pages/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TeachersBloc extends BaseBloc<TeachersModel> {
  final _fetcher = PublishSubject<TeachersModel>();

  Observable<TeachersModel> get data => _fetcher.stream;

  TeachersBloc({repository}) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllTeachers();
    _fetcher.add(model);
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}