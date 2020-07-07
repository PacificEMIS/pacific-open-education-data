part of 'schools_list_bloc.dart';

abstract class SchoolsListEvent extends Equatable {
  const SchoolsListEvent();

  @override
  List<Object> get props => [];
}

class StartedSchoolsListEvent extends SchoolsListEvent {}

class SearchTextChangedSchoolsListEvent extends SchoolsListEvent {
  final String text;

  const SearchTextChangedSchoolsListEvent(this.text);

  @override
  List<Object> get props => [super.props, text];
}

class SchoolSelectedSchoolsListEvent extends SchoolsListEvent {
  final String id;

  const SchoolSelectedSchoolsListEvent(this.id);

  @override
  List<Object> get props => [super.props, id];
}
