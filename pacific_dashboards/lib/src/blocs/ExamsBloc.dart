import 'package:rxdart/rxdart.dart';

import '../models/ExamsModel.dart';

import 'BaseBloc.dart';

class ExamsBloc extends BaseBloc<ExamsModel> {

  final fetcher = PublishSubject<ExamsModel>();

  Observable<ExamsModel> get data => fetcher.stream;

  ExamsBloc( { repository } ) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllExams();
    fetcher.add(model);
  }

  dispose() {
    fetcher.close();
  }
}
