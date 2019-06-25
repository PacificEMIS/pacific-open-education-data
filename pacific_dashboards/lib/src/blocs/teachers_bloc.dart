import 'package:rxdart/rxdart.dart';

import '../models/teachers_model.dart';

import 'base_bloc.dart';

class TeachersBloc extends BaseBloc<TeachersModel> {

  final fetcher = PublishSubject<TeachersModel>();

  Observable<TeachersModel> get data => fetcher.stream;

  TeachersBloc( { repository }) : super(repository: repository);

  fetchData() async {
    var model = await repository.fetchAllTeachers();
    fetcher.add(model);
  }

  dispose() {
    fetcher.close();
  }
}
