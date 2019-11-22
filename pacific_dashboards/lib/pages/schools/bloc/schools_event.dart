import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/schools_model.dart';

abstract class SchoolsEvent extends Equatable {
  const SchoolsEvent();

  @override
  List<Object> get props => [];
}

class StartedSchoolsEvent extends SchoolsEvent {}

class FiltersAppliedSchoolsEvent extends SchoolsEvent {
  const FiltersAppliedSchoolsEvent({@required this.updatedModel});

  final SchoolsModel updatedModel;

  @override
  List<Object> get props => [updatedModel];
}
