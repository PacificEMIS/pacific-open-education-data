import 'package:pacific_dashboards/data/provider.dart';
import 'package:pacific_dashboards/models/exams_model.dart';
import 'package:pacific_dashboards/models/lookups_model.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';

abstract class FileProvider extends Provider {
  Future<bool> saveExamsModel(ExamsModel model);

  Future<bool> saveTeachersModel(TeachersModel model);

  Future<bool> saveSchoolsModel(SchoolsModel model);

  Future<bool> saveSchoolAccreditaitonsChunk(SchoolAccreditationsChunk chunk);

  Future<bool> saveLookupsModel(LookupsModel model);
}