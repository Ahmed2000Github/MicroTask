import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/profile_model.dart';

class ProfileState {
  StateStatus? requestState;
  Profile? profile;
  String? messageError;

  ProfileState({required this.requestState, this.profile, this.messageError});
}
