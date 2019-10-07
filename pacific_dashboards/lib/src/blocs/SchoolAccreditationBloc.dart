import 'package:pacific_dashboards/src/blocs/BaseBloc.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsModel.dart';
import 'package:rxdart/rxdart.dart';

class SchoolAccreditationBloc extends BaseBloc<SchoolAccreditationsModel> {
  final _fetcher = PublishSubject<SchoolAccreditationsModel>();

  Observable<SchoolAccreditationsModel> get data => _fetcher.stream;

  SchoolAccreditationBloc({repository}) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllAccreditaitons();
    _fetcher.add(model);
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}