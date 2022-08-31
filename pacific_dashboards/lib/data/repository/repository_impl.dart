import 'dart:async';

import 'package:arch/arch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/data/data_source/local/local_data_source.dart';
import 'package:pacific_dashboards/data/data_source/remote/remote_data_source.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school/schools_chunk.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/school_exam_report/school_exam_report.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/models/special_education/special_education.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';
import 'package:pacific_dashboards/utils/exceptions.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/exam/exam_separated.dart';

typedef _AuthorizedCallable<T> = FutureOr<T> Function(String);

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

  Stream<RepositoryResponse<T>> _fetchWithoutEtag<T>({
    Future<Pair<bool, T>> getLocal(),
    Future<T> getRemote(),
    Future<void> updateLocal(T remote),
  }) async* {
    final local = await getLocal();
    var result = local.second;
    final isLocalExpired = local.first;

    if (!isLocalExpired && result != null) {
      yield SuccessRepositoryResponse(RepositoryType.local, result);
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
    final localResult = await getLocal();

    if (localResult != null) {
      yield SuccessRepositoryResponse(RepositoryType.local, localResult);
    } else {
      yield FailureRepositoryResponse(RepositoryType.local, NoDataException());
    }

    try {
      final remoteResult = await getRemote();
      if (remoteResult == null) {
        throw NoDataException();
      }
      await updateLocal(remoteResult);
      if (remoteResult != localResult) {
        yield SuccessRepositoryResponse(RepositoryType.remote, remoteResult);
      }
    } on NoNewDataRemoteException catch (_) {
      if (localResult == null) {
        yield FailureRepositoryResponse(
          RepositoryType.remote,
          NoDataException(),
        );
      }
    } catch (ex) {
      print(ex);
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
    }
  }

  Future<T> _callAuthorized<T>(
    _AuthorizedCallable callable, {
    bool isFallback = false,
  }) async {
    final fallback = () async {
      if (isFallback) {
        throw UnauthorizedRemoteException(
          code: 401,
          url: '',
          message: 'Failed to repeat auth',
        );
      }
      final newAccessToken = await _remoteDataSource.fetchAccessToken();
      _localDataSource.saveAccessToken(newAccessToken);
      return _callAuthorized(callable, isFallback: true);
    };

    final savedAccessToken = await _localDataSource.fetchAccessToken();
    if (savedAccessToken == null || savedAccessToken.isEmpty) {
      return await fallback();
    }

    try {
      return await callable.call(savedAccessToken);
    } on UnauthorizedRemoteException catch (_) {
      return await fallback();
    }
  }

  @override
  Stream<RepositoryResponse<List<Teacher>>> fetchAllTeachers() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchTeachers,
      getRemote: _remoteDataSource.fetchTeachers,
      updateLocal: _localDataSource.saveTeachers,
    );
  }

  @override
  Stream<RepositoryResponse<SchoolsChunk>> fetchAllSchools() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchools,
      getRemote: _remoteDataSource.fetchSchools,
      updateLocal: _localDataSource.saveSchools,
    );
  }

  @override
  Stream<RepositoryResponse<List<School>>> fetchAllSchoolsAuthority() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchoolsAuthority,
      getRemote: _remoteDataSource.fetchSchoolsAuthority,
      updateLocal: _localDataSource.saveSchoolsAuthority,
    );
  }

  @override
  Stream<RepositoryResponse<List<ExamSeparated>>> fetchAllExams() async* {
    yield* _fetchWithoutEtag(
      getLocal: _localDataSource.fetchExams,
      getRemote: _remoteDataSource.fetchExamsSeparated,
      updateLocal: _localDataSource.saveExams,
    );
  }

  @override
  Stream<RepositoryResponse<IndicatorsContainer>> fetchAllIndicators(
      String districtCode) async* {
    yield* _fetchWithoutEtag(
      getLocal: () => _localDataSource.fetchIndicators(districtCode),
      getRemote: () => _remoteDataSource.fetchIndicators(districtCode),
      updateLocal: (indicators) =>
          _localDataSource.saveIndicators(indicators, districtCode),
    );
  }

  @override
  Stream<RepositoryResponse<List<Budget>>> fetchAllBudgets() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchBudgets,
      getRemote: _remoteDataSource.fetchBudgets,
      updateLocal: _localDataSource.saveBudgets,
    );
  }

  @override
  Stream<RepositoryResponse<List<SpecialEducation>>>
      fetchAllSpecialEducation() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSpecialEducation,
      getRemote: _remoteDataSource.fetchSpecialEducation,
      updateLocal: _localDataSource.saveSpecialEducation,
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
  Stream<RepositoryResponse<WashChunk>> fetchAllWashChunk() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchWashChunk,
      getRemote: _remoteDataSource.fetchWashChunk,
      updateLocal: _localDataSource.saveWashChunk,
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
              if (localLookups.second == null) {
                return;
              }
              subject.add(localLookups.second);
            };

            Connectivity().checkConnectivity().then((status) {
              if (status == ConnectivityResult.none) {
                return Future.value();
              } else {
                return _remoteDataSource.fetchLookupsModel().then(
                    (remote) => _localDataSource.saveLookupsModel(remote));
              }
            }).then((_) => pushSavedToSubject(), onError: (er) {
              debugPrint('Lookups error: $er');
              pushSavedToSubject();
            });
          }

          return subject;
        });
  }

  @override
  Future<void> refreshLookups() async {
    // ignore: close_sinks
    final currentLookupsSubject =
        await _globalSettings.currentEmis.then((emis) {
      switch (emis) {
        case Emis.miemis:
          return _miemisLookupsSubject;
        case Emis.fedemis:
          return _fedemisLookupsSubject;
        case Emis.kemis:
          return _kemisLookupsSubject;
      }
      throw FallThroughError();
    });

    final remoteData = await _remoteDataSource.fetchLookupsModel();
    await _localDataSource.saveLookupsModel(remoteData);

    currentLookupsSubject.add(remoteData);
  }

  @override
  Stream<RepositoryResponse<SchoolEnrollChunk>> fetchIndividualSchoolEnroll(
    String schoolId,
    String districtCode,
  ) async* {
    final localSchoolEnroll =
        await _localDataSource.fetchIndividualSchoolEnroll(schoolId) ?? [];
    final localDistrictEnroll =
        await _localDataSource.fetchIndividualDistrictEnroll(districtCode) ??
            [];
    final localNationEnroll =
        await _localDataSource.fetchIndividualNationEnroll() ?? [];

    final localHandle = await _handleIndividualSchoolEnrollLocalResults(
      localSchoolEnroll: localSchoolEnroll,
      localDistrictEnroll: localDistrictEnroll,
      localNationEnroll: localNationEnroll,
    );
    final haveLocalResponse = localHandle.first;
    yield localHandle.second;

    try {
      final schoolFetchResult = await _fetchRemoteSchoolEnrollData(
        local: localSchoolEnroll,
        getRemote: () =>
            _remoteDataSource.fetchIndividualSchoolEnroll(schoolId),
        updateLocal: (enroll) => _localDataSource.saveIndividualSchoolEnroll(
          schoolId,
          enroll,
        ),
      );
      final districtFetchResult = await _fetchRemoteSchoolEnrollData(
        local: localDistrictEnroll,
        getRemote: () =>
            _remoteDataSource.fetchIndividualDistrictEnroll(districtCode),
        updateLocal: (enroll) => _localDataSource.saveIndividualDistrictEnroll(
          districtCode,
          enroll,
        ),
      );
      final nationFetchResult = await _fetchRemoteSchoolEnrollData(
        local: localNationEnroll,
        getRemote: _remoteDataSource.fetchIndividualNationEnroll,
        updateLocal: _localDataSource.saveIndividualNationEnroll,
      );
      final haveRemoteChanges = schoolFetchResult.first ||
          districtFetchResult.first ||
          nationFetchResult.first;

      if (haveRemoteChanges) {
        yield SuccessRepositoryResponse(
          RepositoryType.remote,
          await compute<SchoolEnrollChunk, SchoolEnrollChunk>(
            SchoolEnrollChunk.fromNonCollapsed,
            SchoolEnrollChunk(
              schoolData: schoolFetchResult.second,
              districtData: districtFetchResult.second,
              nationalData: nationFetchResult.second,
            ),
          ),
        );
      } else if (!haveLocalResponse) {
        yield FailureRepositoryResponse(
          RepositoryType.remote,
          NoDataException(),
        );
      }
    } catch (ex) {
      yield FailureRepositoryResponse(RepositoryType.remote, ex);
    }
  }

  Future<Pair<bool, List<SchoolEnroll>>> _fetchRemoteSchoolEnrollData({
    @required List<SchoolEnroll> local,
    @required Future<List<SchoolEnroll>> getRemote(),
    @required Future<void> updateLocal(List<SchoolEnroll> remote),
  }) async {
    List<SchoolEnroll> remoteEnroll = [];
    bool haveData = true;
    try {
      remoteEnroll = await getRemote();
      await updateLocal(remoteEnroll);
    } catch (_) {
      haveData = false;
      if (local.isNotEmpty) {
        remoteEnroll = local;
      }
    }
    return Pair(haveData, remoteEnroll);
  }

  Future<Pair<bool, RepositoryResponse<SchoolEnrollChunk>>>
      _handleIndividualSchoolEnrollLocalResults({
    @required List<SchoolEnroll> localSchoolEnroll,
    @required List<SchoolEnroll> localDistrictEnroll,
    @required List<SchoolEnroll> localNationEnroll,
  }) async {
    final bool haveLocalResponse = localSchoolEnroll.isNotEmpty;

    RepositoryResponse<SchoolEnrollChunk> response;
    if (!haveLocalResponse) {
      response = FailureRepositoryResponse(
        RepositoryType.local,
        NoDataException(),
      );
    } else {
      response = SuccessRepositoryResponse(
        RepositoryType.local,
        await compute<SchoolEnrollChunk, SchoolEnrollChunk>(
          SchoolEnrollChunk.fromNonCollapsed,
          SchoolEnrollChunk(
            schoolData: localSchoolEnroll,
            districtData: localDistrictEnroll ?? [],
            nationalData: localNationEnroll ?? [],
          ),
        ),
      );
    }
    return Pair(haveLocalResponse, response);
  }

  @override
  Stream<RepositoryResponse<List<ShortSchool>>> fetchSchoolsList() async* {
    yield* _fetchWithEtag(
      getLocal: _localDataSource.fetchSchoolsList,
      getRemote: () => _callAuthorized(
        (token) => _remoteDataSource.fetchSchoolsList(token),
      ),
      updateLocal: _localDataSource.saveSchoolsList,
    );
  }

  @override
  Stream<RepositoryResponse<List<SchoolFlow>>> fetchIndividualSchoolFlow(
    String schoolId,
  ) async* {
    yield* _fetchWithEtag(
      getLocal: () => _localDataSource.fetchSchoolFlow(schoolId),
      getRemote: () => _remoteDataSource.fetchSchoolFlow(schoolId),
      updateLocal: (flows) => _localDataSource.saveSchoolFlow(schoolId, flows),
    );
  }

  @override
  Stream<RepositoryResponse<List<SchoolExamReport>>> fetchIndividualSchoolExams(
    String schoolId,
  ) async* {
    yield* _fetchWithEtag(
      getLocal: () => _localDataSource.fetchSchoolExamReports(schoolId),
      getRemote: () => _remoteDataSource.fetchSchoolExamReports(schoolId),
      updateLocal: (reports) => _localDataSource.saveSchoolExamReports(
        schoolId,
        reports,
      ),
    );
  }

  @override
  Stream<RepositoryResponse<IndividualSchool>> fetchIndividualSchool(
    String schoolId,
  ) async* {
    yield* _fetchWithEtag(
      getLocal: () => _localDataSource.fetchIndividualSchool(schoolId),
      getRemote: () => _callAuthorized(
        (token) => _remoteDataSource.fetchIndividualSchool(token, schoolId),
      ),
      updateLocal: (school) =>
          _localDataSource.saveIndividualSchool(schoolId, school),
    );
  }
}
