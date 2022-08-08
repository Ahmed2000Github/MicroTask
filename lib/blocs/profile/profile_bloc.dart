import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/profile/profile_event.dart';
import 'package:microtask/blocs/profile/profile_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/login_services.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState(requestState: StateStatus.NONE));
  LoginServices get loginServices => GetIt.I<LoginServices>();
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    switch (event.requestEvent) {
      case ProfileEventState.LOAD:
        try {
          yield ProfileState(requestState: StateStatus.LOADED);
          // final result = await loginServices.getProfile(event.email);
          // yield result == null
          //     ? ProfileState(
          //         requestState: StateStatus.ERROR,
          //         messageError: "No data found with this user.")
          //     : ProfileState(requestState: StateStatus.LOADED, profile: result);
        } catch (e) {
          yield ProfileState(
              requestState: StateStatus.ERROR,
              messageError: "An Error was occured try later.");
        }

        break;
      default:
    }
  }
}
