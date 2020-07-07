part of 'schools_list_bloc.dart';

abstract class SchoolsListState extends Equatable {
  const SchoolsListState();

  @override
  List<Object> get props => [];
}

class SchoolsListInitial extends SchoolsListState {}

class ServerUnavailableState extends SchoolsListState implements ErrorState {}

class UnknownErrorState extends SchoolsListState implements ErrorState {}
