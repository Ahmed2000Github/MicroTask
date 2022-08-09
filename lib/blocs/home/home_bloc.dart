import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.HOME);
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    switch (event) {
      case HomeEvent.HOME:
        yield HomeState.HOME;
        break;
      case HomeEvent.PROFILE:
        yield HomeState.PROFILE;
        break;
      case HomeEvent.SETTINGS:
        yield HomeState.SETTINGS;
        break;
      default:
    }
  }
}

enum HomeEvent { HOME, SETTINGS, PROFILE }
enum HomeState { SETTINGS, HOME, PROFILE }
