import 'package:pacific_dashboards/src/blocs/BaseBloc.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsBloc extends BaseBloc<SchoolsModel> {
  final fetcher = PublishSubject<SchoolsModel>();

  Observable<SchoolsModel> get data => fetcher.stream;

  SchoolsBloc({repository}) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllSchools();
    fetcher.add(model);
  }

  dispose() {
    fetcher.close();
  }
}
