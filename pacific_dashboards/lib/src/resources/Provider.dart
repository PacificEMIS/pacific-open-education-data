import 'package:pacific_dashboards/src/models/ExamsModel.dart';
import 'package:pacific_dashboards/src/models/LookupsModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/src/models/SchoolsModel.dart';
import 'package:pacific_dashboards/src/models/TeachersModel.dart';

abstract class Provider {
  Future<TeachersModel> fetchTeachersModel();

  Future<SchoolsModel> fetchSchoolsModel();

  Future<ExamsModel> fetchExamsModel();

  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk();
  
  Future<LookupsModel> fetchLookupsModel();
}