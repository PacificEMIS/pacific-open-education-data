import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';

abstract class TeachersEvent extends Equatable {
  const TeachersEvent();

  @override
  List<Object> get props => [];
}

class StartedTeachersEvent extends TeachersEvent {}

class FiltersAppliedTeachersEvent extends TeachersEvent {
  const FiltersAppliedTeachersEvent({@required this.filters});

  final BuiltList<Filter> filters;

  @override
  List<Object> get props => [filters];
}