import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/task/task_state.dart';
import 'package:microtask/blocs/today/today_event.dart';
import 'package:microtask/blocs/today/today_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/services/task_services.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  TodayBloc() : super(TodayState(requestState: StateStatus.NONE));
  TaskServices get taskServices => GetIt.I<TaskServices>();
  @override
  Stream<TodayState> mapEventToState(TodayEvent event) async* {
    switch (event.requestEvent) {
      case CrudEventStatus.FETCH:
        try {
          yield TodayState(requestState: StateStatus.LOADING);
          final result = taskServices.getTodayTasks();

          result.sort((a, b) {
            if (b.status == TaskStatus.DONE) {
              return 1;
            }
            return -1;
          });
          yield TodayState(
              requestState: StateStatus.LOADED, todayTasks: result);
        } catch (e) {
          print(' $e');
          yield TodayState(requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESET:
        yield TodayState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
