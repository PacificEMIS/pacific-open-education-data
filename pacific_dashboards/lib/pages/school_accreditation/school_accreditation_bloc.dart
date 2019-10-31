import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/pages/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SchoolAccreditationBloc extends BaseBloc<SchoolAccreditationsChunk> {
  final _fetcher = PublishSubject<SchoolAccreditationsChunk>();

  Observable<SchoolAccreditationsChunk> get data => _fetcher.stream;

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