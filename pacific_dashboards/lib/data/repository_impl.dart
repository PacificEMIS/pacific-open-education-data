import 'package:pacific_dashboards/data/local/file_provider.dart';
import 'package:pacific_dashboards/data/provider.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';

class RepositoryImpl implements Repository {
  final Provider _backendProvider;
  final FileProvider _fileProvider;

  RepositoryImpl(this._backendProvider, this._fileProvider);

  @override
  Stream<RepositoryResponse<TeachersModel>> fetchAllTeachers() async* {
    yield* _fetchWithoutEtag(
      getLocal: _fileProvider.fetchTeachersModel,
      getRemote: _backendProvider.fetchTeachersModel,
      updateLocal: _fileProvider.saveTeachersModel,
      lookupsSetter: (result, lookups) => result.lookupsModel = lookups,
    );
  }

  @override
  Stream<RepositoryResponse<SchoolsModel>> fetchAllSchools() async* {
    yield* _fetchWithEtag(
      getLocal: _fileProvider.fetchSchoolsModel,
      getRemote: _backendProvider.fetchSchoolsModel,
      updateLocal: _fileProvider.saveSchoolsModel,
      lookupsSetter: (result, lookups) => result.lookupsModel = lookups,
    );
  }

  @override
  Stream<RepositoryResponse<ExamsModel>> fetchAllExams() async* {
    yield* _fetchWithoutEtag(
      getLocal: _fileProvider.fetchExamsModel,
      getRemote: _backendProvider.fetchExamsModel,
      updateLocal: _fileProvider.saveExamsModel,
      lookupsSetter: (result, lookups) => result.lookupsModel = lookups,
    );
  }

  @override
  Stream<RepositoryResponse<SchoolAccreditationsChunk>>
      fetchAllAccreditaitons() async* {
    yield* _fetchWithEtag(
      getLocal: _fileProvider.fetchSchoolAccreditationsChunk,
      getRemote: _backendProvider.fetchSchoolAccreditationsChunk,
      updateLocal: _fileProvider.saveSchoolAccreditaitonsChunk,
      lookupsSetter: (result, lookups) {
        result.statesChunk.lookupsModel = lookups;
        result.standardsChunk.lookupsModel = lookups;
      },
    );
  }

  Future<LookupsModel> _fetchAllLookups() async {
    LookupsModel result;

    result = await _fileProvider.fetchLookupsModel();

    if (result == null) {
      result = await _backendProvider.fetchLookupsModel();
      await _fileProvider.saveLookupsModel(result);
    }

    if (result == null) throw NoDataException();

    return result;
  }

  Stream<RepositoryResponse<T>> _fetchWithoutEtag<T>({
    Future<T> getLocal(),
    Future<T> getRemote(),
    Future<void> updateLocal(T remote),
    void lookupsSetter(T result, LookupsModel lookups),
  }) async* {
    LookupsModel lookups;
    try {
      lookups = await _fetchAllLookups();
    } catch (ex) {
      yield FailureRepositoryResponse(RepositoryType.local, ex);
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
      return;
    }

    T result = await getLocal();

    if (result != null) {
      lookupsSetter(result, lookups);
      yield SuccessRepositoryResponse(RepositoryType.local, result);
      yield SuccessRepositoryResponse(RepositoryType.remote, result);
    } else {
      yield FailureRepositoryResponse(RepositoryType.local, NoDataException());
      try {
        result = await getRemote();
        await updateLocal(result);
        lookupsSetter(result, lookups);
        yield SuccessRepositoryResponse(RepositoryType.remote, result);
      } catch (ex) {
        yield FailureRepositoryResponse(RepositoryType.remote, ex);
      }
    }
  }

  Stream<RepositoryResponse<T>> _fetchWithEtag<T>({
    Future<T> getLocal(),
    Future<T> getRemote(),
    Future<void> updateLocal(T remote),
    void lookupsSetter(T result, LookupsModel lookups),
  }) async* {
    LookupsModel lookups;
    try {
      lookups = await _fetchAllLookups();
    } catch (ex) {
      yield FailureRepositoryResponse(RepositoryType.local, ex);
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
      return;
    }

    T result = await getLocal();

    if (result != null) {
      lookupsSetter(result, lookups);
      yield SuccessRepositoryResponse(RepositoryType.local, result);
    } else {
      yield FailureRepositoryResponse(RepositoryType.local, NoDataException());
    }

    try {
      result = await getRemote();
      await updateLocal(result);
      lookupsSetter(result, lookups);
      yield SuccessRepositoryResponse(RepositoryType.remote, result);
    } on NoNewDataRemoteException catch (_) {
      if (result != null) {
        yield SuccessRepositoryResponse(RepositoryType.remote, result);
      } else {
        yield FailureRepositoryResponse(
            RepositoryType.remote, NoDataException());
      }
    } catch (ex) {
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
    }
  }
}
