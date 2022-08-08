class ProfileEvent {
  ProfileEventState? requestEvent;
  String? email;

  ProfileEvent({this.requestEvent, this.email});
}

enum ProfileEventState { LOAD }
