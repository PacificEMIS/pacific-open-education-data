import 'package:pacific_dashboards/models/ExamsModel.dart';
import 'package:pacific_dashboards/models/LookupsModel.dart';
import 'package:pacific_dashboards/models/SchoolAccreditationsChunk.dart';
import 'package:pacific_dashboards/models/SchoolsModel.dart';
import 'package:pacific_dashboards/models/TeachersModel.dart';

abstract class Provider {
  Future<TeachersModel> fetchTeachersModel();

  Future<SchoolsModel> fetchSchoolsModel();

  Future<ExamsModel> fetchExamsModel();

  Future<SchoolAccreditationsChunk> fetchSchoolAccreditationsChunk();
  
  Future<LookupsModel> fetchLookupsModel();
}