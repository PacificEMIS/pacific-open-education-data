import 'package:pacific_dashboards/data/local/file_provider.dart';
import 'package:pacific_dashboards/data/provider.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/utils/Exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryImpl implements Repository {
  final Provider _backendProvider;
  final FileProvider _fileProvider;

  RepositoryImpl(Provider backendProvider, FileProvider fileProvider,
      SharedPreferences sharedPreferences)
      : _backendProvider = backendProvider,
        _fileProvider = fileProvider;

  @override
  Future<TeachersModel> fetchAllTeachers() async {
    final lookups = await fetchAllLookups();
    // TeachersModel result;

    // try {
    //   result = await _backendProvider.fetchTeachersModel();
    //   await _fileProvider.saveTeachersModel(result);
    // } on NoNewRemoteDataException catch (_) {
    //   result = await _fileProvider.fetchTeachersModel();
    // }

    // result.lookupsModel = lookups;
    // return result;
    // TODO: deprecated. Use code above when ETag will be added to request
    TeachersModel result;

    result = await _fileProvider.fetchTeachersModel();
    if (result == null) {
      try {
        result = await _backendProvider.fetchTeachersModel();
        await _fileProvider.saveTeachersModel(result);
      } on NoNewRemoteDataException catch (_) {
        // nothing: silence ETag presence 
      }
    }

    if (result != null) {
      result.lookupsModel = lookups;
    }

    return result;
  }

  @override
  Future<SchoolsModel> fetchAllSchools() async {
    final lookups = await fetchAllLookups();
    SchoolsModel result;

    try {
      result = await _backendProvider.fetchSchoolsModel();
      await _fileProvider.saveSchoolsModel(result);
    } on NoNewRemoteDataException catch (_) {
      result = await _fileProvider.fetchSchoolsModel();
    }

    result.lookupsModel = lookups;
    return result;
  }

  @override
  Future<ExamsModel> fetchAllExams() async {
    final lookups = await fetchAllLookups();
    // ExamsModel result;

    // try {
    //   result = await _backendProvider.fetchExamsModel();
    //   await _fileProvider.saveExamsModel(result);
    // } on NoNewRemoteDataException catch (_) {
    //   result = await _fileProvider.fetchExamsModel();
    // }

    // result.lookupsModel = lookups;
    // return result;
    // TODO: deprecated. Use code above when ETag will be added to request
    ExamsModel result;

    result = await _fileProvider.fetchExamsModel();
    if (result == null) {
      try {
        result = await _backendProvider.fetchExamsModel();
        await _fileProvider.saveExamsModel(result);
      } on NoNewRemoteDataException catch (_) {
        // nothing: silence ETag presence 
      }
    }

    if (result != null) {
      result.lookupsModel = lookups;
    }

    return result;
  }

  @override
  Future<SchoolAccreditationsChunk> fetchAllAccreditaitons() async {
    final lookups = await fetchAllLookups();
    SchoolAccreditationsChunk result;

    try {
      result = await _backendProvider.fetchSchoolAccreditationsChunk();
      await _fileProvider.saveSchoolAccreditaitonsChunk(result);
    } on NoNewRemoteDataException catch (_) {
      result = await _fileProvider.fetchSchoolAccreditationsChunk();
    }

    result.statesChunk.lookupsModel = lookups;
    result.standardsChunk.lookupsModel = lookups;
    return result;
  }

  @override
  Future<LookupsModel> fetchAllLookups() async {
    // LookupsModel result;

    // try {
    //   result = await _backendProvider.fetchLookupsModel();
    //   await _fileProvider.saveLookupsModel(result);
    // } on NoNewRemoteDataException catch (_) {
    //   result = await _fileProvider.fetchLookupsModel();
    // }

    // return result;
    // TODO: deprecated. Use code above when ETag will be added to request
    LookupsModel result;

    result = await _fileProvider.fetchLookupsModel();
    if (result == null) {
      try {
        result = await _backendProvider.fetchLookupsModel();
        await _fileProvider.saveLookupsModel(result);
      } on NoNewRemoteDataException catch (_) {
        // nothing: silence ETag presence 
      }
    }

    return result;
  }
}
