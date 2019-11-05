import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';

abstract class AccreditationEvent extends Equatable {
  const AccreditationEvent();  
  
  @override
  List<Object> get props => [];
}

class StartedAccreditationEvent extends AccreditationEvent {}

class FiltersAppliedAccreditationEvent extends AccreditationEvent {
  const FiltersAppliedAccreditationEvent({@required this.updatedModel});

  final SchoolAccreditationsChunk updatedModel;

  @override
  List<Object> get props => [updatedModel];
}
