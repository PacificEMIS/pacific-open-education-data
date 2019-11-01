import 'package:equatable/equatable.dart';

abstract class SchoolsEvent extends Equatable {
  const SchoolsEvent();

  @override
  List<Object> get props => [];
}

class StartedSchoolsEvent extends SchoolsEvent {}
