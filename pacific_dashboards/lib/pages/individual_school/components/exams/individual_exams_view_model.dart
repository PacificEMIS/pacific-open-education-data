import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';

class IndividualExamsViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;

  IndividualExamsViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);
}
