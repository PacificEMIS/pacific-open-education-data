import 'package:rxdart/rxdart.dart';

import '../models/TeachersModel.dart';

import 'BaseBloc.dart';

class TeachersBloc extends BaseBloc<TeachersModel> {

  final fetcher = PublishSubject<TeachersModel>();

  Observable<TeachersModel> get data => fetcher.stream;

  TeachersBloc( { repository }) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllTeachers();
    print('fetchData');
    fetcher.add(model);
  }

  dispose() {
    fetcher.close();
  }
}
