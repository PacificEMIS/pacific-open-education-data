import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';

abstract class AccreditationState extends Equatable {
  const AccreditationState();

  @override
  List<Object> get props => [];
}

class InitialAccreditationState extends AccreditationState {}

class LoadingAccreditationState extends AccreditationState {}

class UpdatedAccreditationState extends AccreditationState {
  const UpdatedAccreditationState(this.data);

  final AccreditationData data;

  @override
  List<Object> get props => [data];
}

class ServerUnavailableState extends AccreditationState implements ErrorState {}

class UnknownErrorState extends AccreditationState implements ErrorState {}
