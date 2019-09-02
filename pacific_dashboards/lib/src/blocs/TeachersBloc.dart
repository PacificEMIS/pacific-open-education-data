import 'package:pacific_dashboards/src/blocs/BaseBloc.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';
import 'package:rxdart/rxdart.dart';

class TeachersBloc extends BaseBloc<TeachersModel> {
  final _fetcher = PublishSubject<TeachersModel>();

  Observable<TeachersModel> get data => _fetcher.stream;

  TeachersBloc({repository}) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllTeachers();
    _fetcher.add(model);
  }

  dispose() {
    _fetcher.close();
  }
}
