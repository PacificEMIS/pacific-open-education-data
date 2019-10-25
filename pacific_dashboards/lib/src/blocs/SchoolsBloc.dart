import 'package:pacific_dashboards/src/blocs/BaseBloc.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsBloc extends BaseBloc<SchoolsModel> {
  final _fetcher = PublishSubject<SchoolsModel>();

  Observable<SchoolsModel> get data => _fetcher.stream;

  SchoolsBloc({repository}) : super(repository: repository);

  fetchData() async {
    try {
      _fetcher.add(await repository.fetchAllSchools());
    } catch (e) {
      _fetcher.addError(e);
    }
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}
