import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:microtask/enums/state_enum.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, StateStatus> {
  VerifyEmailBloc() : super(StateStatus.NONE);
  @override
  Stream<StateStatus> mapEventToState(VerifyEmailEvent event) async* {
    switch (event.status) {
      case EventVerifyStatus.VERIFY:
        try {
          yield StateStatus.LOADED;

          yield StateStatus.LOADED;
        } catch (e) {
          yield StateStatus.ERROR;
        }

        break;
      case EventVerifyStatus.NONE:
        yield StateStatus.NONE;
        break;
      default:
    }
  }
}

class VerifyEmailEvent {
  String email;
  EventVerifyStatus status;
  VerifyEmailEvent({required this.email, required this.status});
}

enum EventVerifyStatus { NONE, VERIFY }
