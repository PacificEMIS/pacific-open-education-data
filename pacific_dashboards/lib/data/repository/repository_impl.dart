import 'package:built_collection/built_collection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/data_source/data_source.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/teachers/teacher.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryImpl implements Repository {
  final DataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final GlobalSettings _globalSettings;

  final BehaviorSubject<Lookups> _fedemisLookupsSubject = BehaviorSubject();
  final BehaviorSubject<Lookups> _miemisLookupsSubject = BehaviorSubject();
  final BehaviorSubject<Lookups> _kemisLookupsSubject = BehaviorSubject();

  RepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._globalSettings);

  void dispose() {
    _fedemisLookupsSubject.close();
    _miemisLookupsSubject.close();
    _kemisLookupsSubject.close();
  }

  @override
  Stream<RepositoryResponse<BuiltList<Teacher>>> fetchAllTeachers() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchTeachers,
      getRemote: _remoteDataSource.fetchTeachers,
      updateLocal: _localDataSource.saveTeachers,
    );
  }

  @override
  Stream<RepositoryResponse<BuiltList<School>>> fetchAllSchools() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchools,
      getRemote: _remoteDataSource.fetchSchools,
      updateLocal: _localDataSource.saveSchools,
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
    return _globalSettings.currentEmis
        .then((emis) {
          switch (emis) {
            case Emis.miemis:
              return _miemisLookupsSubject;
            case Emis.fedemis:
              return _fedemisLookupsSubject;
            case Emis.kemis:
              return _kemisLookupsSubject;
          }
          throw FallThroughError();
        })
        .asStream()
        .flatMap((subject) {
          if (!subject.hasValue) {
            final pushSavedToSubject = () async {
              final localLookups = await _localDataSource.fetchLookupsModel();
              if (localLookups == null) {
                return;
              }
              subject.add(localLookups);
            };

            Connectivity().checkConnectivity().then((status) {
              if (status == ConnectivityResult.none) {
                return Future.value();
              } else {
                return _remoteDataSource.fetchLookupsModel().then(
                    (remote) => _localDataSource.saveLookupsModel(remote));
              }
            }).then((_) => pushSavedToSubject(),
                onError: (er) => pushSavedToSubject());
          }

          return subject;
        });
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
      print(ex);
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
    }
  }
}
