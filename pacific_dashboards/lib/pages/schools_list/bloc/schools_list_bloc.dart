import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';

part 'schools_list_event.dart';
part 'schools_list_state.dart';

class SchoolsListBloc extends BaseBloc<SchoolsListEvent, SchoolsListState> {
  final Repository _repository;

  SchoolsListBloc({
    @required Repository repository,
  })  : assert(repository != null),
        _repository = repository,
        super(SchoolsListInitial());

  @override
  Stream<Lookups> get lookupsStream => _repository.lookups;

  @override
  SchoolsListState get serverUnavailableState => ServerUnavailableState();

  @override
  SchoolsListState get unknownErrorState => UnknownErrorState();

  @override
  Stream<SchoolsListState> mapEventToState(
    SchoolsListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
