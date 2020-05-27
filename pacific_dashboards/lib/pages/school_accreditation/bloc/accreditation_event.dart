import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';

abstract class AccreditationEvent extends Equatable {
  const AccreditationEvent();  
  
  @override
  List<Object> get props => [];
}

class StartedAccreditationEvent extends AccreditationEvent {}

class FiltersAppliedAccreditationEvent extends AccreditationEvent {
  const FiltersAppliedAccreditationEvent({@required this.filters});

  final List<Filter> filters;

  @override
  List<Object> get props => [filters];
}
