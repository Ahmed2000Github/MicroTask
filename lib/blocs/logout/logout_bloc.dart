import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/sync_services.dart';
import 'package:microtask/services/task_services.dart';

class LogoutBloc extends Bloc<LogoutEvent, StateStatus> {
  LogoutBloc() : super(StateStatus.NONE);
  SyncServices get syncServices => GetIt.I<SyncServices>();
  TaskServices get taskServices => GetIt.I<TaskServices>();
  @override
  Stream<StateStatus> mapEventToState(LogoutEvent event) async* {
    switch (event) {
      case LogoutEvent.LOGOUT:
        try {
          yield StateStatus.LOADING;
          syncServices.clear();
          yield StateStatus.LOADED;
        } catch (e) {
          print('error $e');
          yield StateStatus.ERROR;
        }

        break;
      default:
    }
  }
}

enum LogoutEvent { LOGOUT }
