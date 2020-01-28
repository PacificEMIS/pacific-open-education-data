import 'package:connectivity/connectivity.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/data_source/data_source.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryImpl implements Repository {
  final DataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  final BehaviorSubject<Lookups> _lookupsSubject = BehaviorSubject();

  RepositoryImpl(this._remoteDataSource, this._localDataSource);

  void dispose() {
    _lookupsSubject.close();
  }

  @override
  Stream<RepositoryResponse<TeachersModel>> fetchAllTeachers() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchTeachersModel,
      getRemote: _remoteDataSource.fetchTeachersModel,
      updateLocal: _localDataSource.saveTeachersModel,
    );
  }

  @override
  Stream<RepositoryResponse<SchoolsModel>> fetchAllSchools() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchoolsModel,
      getRemote: _remoteDataSource.fetchSchoolsModel,
      updateLocal: _localDataSource.saveSchoolsModel,
    );
  }

  @override
  Stream<RepositoryResponse<ExamsModel>> fetchAllExams() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchExamsModel,
      getRemote: _remoteDataSource.fetchExamsModel,
      updateLocal: _localDataSource.saveExamsModel,
    );
  }

  @override
  Stream<RepositoryResponse<SchoolAccreditationsChunk>>
      fetchAllAccreditations() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchoolAccreditationsChunk,
      getRemote: _remoteDataSource.fetchSchoolAccreditationsChunk,
      updateLocal: _localDataSource.saveSchoolAccreditationsChunk,
    );
  }

  @override
  Stream<Lookups> get lookups {
    if (!_lookupsSubject.hasValue) {
      final pushSavedToSubject = () async {
        final localLookups = await _localDataSource.fetchLookupsModel();
        if (localLookups == null) {
          return;
        }
        _lookupsSubject.add(localLookups);
      };

      Connectivity().checkConnectivity().then((status) {
        if (status == ConnectivityResult.none) {
          return Future.value();
        } else {
          return _remoteDataSource
              .fetchLookupsModel()
              .then((remote) => _localDataSource.saveLookupsModel(remote));
        }
      }).then((_) => pushSavedToSubject(),
          onError: (er) => pushSavedToSubject());
    }

    return _lookupsSubject;
  }

  Stream<RepositoryResponse<T>> _fetchWithoutEtag<T>({
    Future<T> getLocal(),
    Future<T> getRemote(),
    Future<void> updateLocal(T remote),
  }) async* {
    T result = await getLocal();

    if (result != null) {
      yield SuccessRepositoryResponse(RepositoryType.local, result);
      yield SuccessRepositoryResponse(RepositoryType.remote, result);
    } else {
      yield FailureRepositoryResponse(RepositoryType.local, NoDataException());
      try {
        result = await getRemote();
        await updateLocal(result);
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
  }) async* {
    T result = await getLocal();

    if (result != null) {
      yield SuccessRepositoryResponse(RepositoryType.local, result);
    } else {
      yield FailureRepositoryResponse(RepositoryType.local, NoDataException());
    }

    try {
      result = await getRemote();
      if (result == null) {
        throw NoDataException();
      }
      await updateLocal(result);
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
