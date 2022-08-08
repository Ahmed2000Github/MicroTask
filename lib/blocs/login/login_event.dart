import '../../enums/event_state.dart';

class LoginEvent {
  LoginEventStatus? requestEvent;
  Map<String, dynamic>? data;

  LoginEvent({this.requestEvent, this.data});
}
