import 'package:microtask/enums/state_enum.dart';

class LoginState {
  StateStatus? requestState;
  String? errorMessage;

  LoginState({this.requestState, this.errorMessage});
}
