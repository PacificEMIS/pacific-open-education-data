import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';

abstract class SchoolsEvent extends Equatable {
  const SchoolsEvent();

  @override
  List<Object> get props => [];
}

class StartedSchoolsEvent extends SchoolsEvent {}

class FiltersAppliedSchoolsEvent extends SchoolsEvent {
  const FiltersAppliedSchoolsEvent({@required this.filters});

  final List<Filter> filters;

  @override
  List<Object> get props => [filters];
}
