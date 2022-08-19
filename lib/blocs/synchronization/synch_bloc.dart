import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/sync_services.dart';
import 'package:microtask/services/task_services.dart';

class SyncBloc extends Bloc<SyncEvent, StateStatus> {
  SyncBloc() : super(StateStatus.NONE);
  SyncServices get syncServices => GetIt.I<SyncServices>();
  TaskServices get taskServices => GetIt.I<TaskServices>();
  @override
  Stream<StateStatus> mapEventToState(SyncEvent event) async* {
    switch (event) {
      case SyncEvent.SYNC:
        try {
          yield StateStatus.LOADING;
          await syncServices.synchronizeFromDevise();
          yield StateStatus.LOADED;
        } catch (e) {
          print('error $e');
          yield StateStatus.ERROR;
        }

        break;
      case SyncEvent.SYNCLOGIN:
        try {
          yield StateStatus.LOADING;
          await syncServices.synchronizeFromCloud();
          taskServices.resetNotification();
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

enum SyncEvent { SYNC, SYNCLOGIN }
