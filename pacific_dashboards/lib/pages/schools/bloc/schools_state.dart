import 'package:equatable/equatable.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';

abstract class SchoolsState extends Equatable {
  const SchoolsState();

  @override
  List<Object> get props => [];
}

class LoadingSchoolsState extends SchoolsState {}

class LoadedSchoolsState extends SchoolsState {
  const LoadedSchoolsState(this.data);

  final SchoolsPageData data;

  @override
  List<Object> get props => [data];
}