import 'package:built_collection/built_collection.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

abstract class Repository {
  Stream<RepositoryResponse<TeachersModel>> fetchAllTeachers();

  Stream<RepositoryResponse<BuiltList<School>>> fetchAllSchools();

  Stream<RepositoryResponse<ExamsModel>> fetchAllExams();

  Stream<RepositoryResponse<SchoolAccreditationsChunk>> fetchAllAccreditations();

  Stream<Lookups> get lookups;
}

abstract class RepositoryResponse<T> {
  const RepositoryResponse(this.data, this.exception, this.type);
  final T data;
  final Exception exception;
  final RepositoryType type;
}

class SuccessRepositoryResponse<T> extends RepositoryResponse<T> {
  SuccessRepositoryResponse(RepositoryType type, T data)
      : super(data, null, type);
}

class FailureRepositoryResponse<T> extends RepositoryResponse<T> {
  FailureRepositoryResponse(RepositoryType type, Exception exception)
      : super(null, exception, type);
}

enum RepositoryType {
  local, remote
}
