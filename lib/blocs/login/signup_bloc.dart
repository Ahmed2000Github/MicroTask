import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/excepion_handler_services.dart';
import 'package:microtask/services/login_services.dart';

class SingupBloc extends Bloc<LoginEvent, LoginState> {
  SingupBloc() : super(LoginState(requestState: StateStatus.NONE));

  LoginServices get loginServices => GetIt.I<LoginServices>();
  ExceptionHandler get exceptionHandler => GetIt.I<ExceptionHandler>();
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      switch (event.requestEvent) {
        case LoginEventStatus.NONE:
          yield LoginState(requestState: StateStatus.NONE);

          break;
        case LoginEventStatus.REGISTER:
          yield LoginState(requestState: StateStatus.LOADING);
          try {
            final result = await InternetAddress.lookup('google.com');

            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              final birthDay =
                  DateTime.parse(event.data!['birthDay'] + " 00:00:00");
              bool result = await loginServices.registerService(
                  event.data?['firstName'].trim(),
                  event.data?['lastName'].trim(),
                  birthDay,
                  event.data?['gender'],
                  event.data?['image'],
                  event.data?['email'].trim(),
                  event.data?['username'].trim(),
                  event.data?['password']);
              yield LoginState(requestState: StateStatus.LOADED);
            }
          } on SocketException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: await exceptionHandler.handleSocketException(e));
          } on FirebaseAuthException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage:
                    await exceptionHandler.handleFirebaseAuthException(e));
          } catch (e) {
            print('errro $e');
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: await exceptionHandler.handleException(e));
          }
          break;

        default:
          break;
      }
    } catch (e) {
      yield LoginState(requestState: StateStatus.ERROR);
    }
  }
}
