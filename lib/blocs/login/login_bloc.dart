import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/login/login_event.dart';
import 'package:microtask/blocs/login/login_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/login_services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(requestState: StateStatus.NONE));

  LoginServices get loginServices => GetIt.I<LoginServices>();
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      switch (event.requestEvent) {
        case LoginEventStatus.LOGIN:
          yield LoginState(requestState: StateStatus.LOADING);
          print('start');
          try {
            final result = await InternetAddress.lookup('google.com');
            print(result.isNotEmpty && result[0].rawAddress.isNotEmpty);
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              bool result = await loginServices.loginService(
                  event.data?['email'].trim() ?? '',
                  event.data?['password'] ?? '');
              if (result) {
                LoginServices.isEnterFromLogin = true;
              }

              yield LoginState(requestState: StateStatus.LOADED);
            }
          } on SocketException catch (_) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: 'You are not connected');
          } on FirebaseAuthException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: e.code.replaceAll('-', ' ').toUpperCase());
          } catch (e) {
            print('errro $e');
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: e.toString().split('Exception: ')[1]);
          }

          break;
        case LoginEventStatus.NONE:
          yield LoginState(requestState: StateStatus.NONE);

          break;

        default:
          break;
      }
    } catch (e) {
      yield LoginState(requestState: StateStatus.ERROR);
    }
  }
}
