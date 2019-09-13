import 'package:pacific_dashboards/src/blocs/BaseBloc.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsBloc extends BaseBloc<SchoolsModel> {
  final _fetcher = PublishSubject<SchoolsModel>();

  Observable<SchoolsModel> get data => _fetcher.stream;

  SchoolsBloc({repository}) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllSchools();
    _fetcher.add(model);
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}
