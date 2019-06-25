import 'package:pacific_dashboards/src/models/teachers_model.dart';

import 'base_bloc.dart';

class TeachersBloc extends BaseBloc<TeachersModel> {
  fetchData() async {
    var model = await repository.fetchAllTeachers();
    fetcher.add(model);
  }

  dispose() {
    fetcher.close();
  }
}

final bloc = TeachersBloc();
