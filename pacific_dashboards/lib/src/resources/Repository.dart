import 'dart:async';
import '../models/TeachersModel.dart';

abstract class Repository {
  Future<TeachersModel> fetchAllTeachers();
}
