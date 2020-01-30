import 'package:built_collection/built_collection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
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
  Stream<RepositoryResponse<BuiltList<Exam>>> fetchAllExams() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchExams,
      getRemote: _remoteDataSource.fetchExams,
      updateLocal: _localDataSource.saveExams,
    );
  }

  @override
  Stream<RepositoryResponse<AccreditationChunk>>
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
              if (localLookups.v2 == null) {
                return;
              }
              subject.add(localLookups.v2);
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
    Future<Pair<bool, T>> getLocal(),
    Future<T> getRemote(),
    Future<void> updateLocal(T remote),
  }) async* {
    final local = await getLocal();
    var result = local.v2;
    final isLocalExpired = local.v1;

    if (!isLocalExpired && result != null) {
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
