import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';

abstract class SchoolsState extends Equatable {
  const SchoolsState();

  @override
  List<Object> get props => [];
}

class InitialSchoolsState extends SchoolsState {}

class ServerUnavailableState extends SchoolsState implements ErrorState {}

class UnknownErrorState extends SchoolsState implements ErrorState {}

class LoadingSchoolsState extends SchoolsState {}

class UpdatedSchoolsState extends SchoolsState {
  const UpdatedSchoolsState(this.data);

  final SchoolsPageData data;

  @override
  List<Object> get props => [data];
}