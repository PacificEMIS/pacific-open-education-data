import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  @override
  ExamsState get initialState => InitialExamsState();

  @override
  Stream<ExamsState> mapEventToState(
    ExamsEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
