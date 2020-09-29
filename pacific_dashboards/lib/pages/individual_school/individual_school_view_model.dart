import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';

class IndividualSchoolViewModel extends BaseViewModel {
  final Repository _repository;

  IndividualSchoolViewModel(
    BuildContext ctx, {
    @required Repository repository,
  })  : assert(repository != null),
        _repository = repository,
        super(ctx);
}
