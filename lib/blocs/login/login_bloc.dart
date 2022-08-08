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
          try {
            bool result = await loginServices.loginService(
                event.data?['email'].trim() ?? '',
                event.data?['password'] ?? '');
            yield result
                ? LoginState(requestState: StateStatus.LOADED)
                : LoginState(
                    requestState: StateStatus.ERROR,
                    errorMessage: "unkown Error occured try later !! !!");
          } on FirebaseAuthException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: e.code.replaceAll('-', ' ').toUpperCase());
          } catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: "unkown Error occured try later !!");
          }

          break;
        case LoginEventStatus.NONE:
          yield LoginState(requestState: StateStatus.NONE);

          break;
        case LoginEventStatus.REGISTER:
          yield LoginState(requestState: StateStatus.LOADING);
          try {
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
            yield result
                ? LoginState(requestState: StateStatus.LOADED)
                : LoginState(
                    requestState: StateStatus.ERROR,
                    errorMessage: "unkown Error occured try later !! !!");
          } on FirebaseAuthException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: e.code.replaceAll('-', ' ').toUpperCase());
          } catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: "unkown Error occured try later !!");
          }
          break;
        case LoginEventStatus.RESETPASSWORD:
          yield LoginState(requestState: StateStatus.LOADING);
          try {
            bool result = await loginServices.resetPassword(
                event.data?['email'].trim(), event.data?['password']);
            yield result
                ? LoginState(requestState: StateStatus.LOADED)
                : LoginState(
                    requestState: StateStatus.ERROR,
                    errorMessage: "unkown Error occured try later !! !!");
          } on FirebaseAuthException catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: e.code.replaceAll('-', ' ').toUpperCase());
          } catch (e) {
            yield LoginState(
                requestState: StateStatus.ERROR,
                errorMessage: "unkown Error occured try later !!");
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
