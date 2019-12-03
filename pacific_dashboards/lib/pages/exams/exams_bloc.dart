import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/pages/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ExamsBloc extends BaseBloc<ExamsModel> {
  final _fetcher = PublishSubject<ExamsModel>();

  Observable<ExamsModel> get data => _fetcher.stream;

  ExamsBloc({repository}) : super(repository: repository);

  fetchData() async {
    final examsStream = repository.fetchAllExams();
    await for (var it in examsStream) {
      _fetcher.add(it.data);
    }
  }

  dispose() async {
    await _fetcher.drain();
    _fetcher.close();
  }
}
