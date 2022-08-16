import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/reminder/reminder_event.dart';
import 'package:microtask/blocs/reminder/reminder_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/task_services.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderState(requestSatus: StateStatus.NONE));
  TaskServices get taskServices => GetIt.I<TaskServices>();
  @override
  Stream<ReminderState> mapEventToState(ReminderEvent event) async* {
    switch (event.requestEvent) {
      case ReminderEventStatus.INCOMING:
        yield ReminderState(requestSatus: StateStatus.LOADING);
        try {
          final result = taskServices.getIcomingReminderTasks();
          result.sort((task1, task2) =>
              task2.startDateTime!.compareTo(task1.startDateTime!));
          yield ReminderState(requestSatus: StateStatus.LOADED, tasks: result);
        } catch (e) {
          yield ReminderState(
              requestSatus: StateStatus.ERROR, errormessage: "$e");
        }
        break;
      case ReminderEventStatus.TODAY:
        yield ReminderState(requestSatus: StateStatus.LOADING);
        try {
          final result = taskServices.getTodayReminderTasks();
          result.sort((task1, task2) =>
              task2.startDateTime!.compareTo(task1.startDateTime!));
          yield ReminderState(requestSatus: StateStatus.LOADED, tasks: result);
        } catch (e) {
          yield ReminderState(
              requestSatus: StateStatus.ERROR, errormessage: "$e");
        }
        break;
      default:
    }
  }
}
