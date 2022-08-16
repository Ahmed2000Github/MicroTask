import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/task/task_event.dart';
import 'package:microtask/blocs/task/task_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/services/task_services.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState(requestState: StateStatus.NONE));
  TaskServices get taskServices => GetIt.I<TaskServices>();
  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    switch (event.requestEvent) {
      case CrudEventStatus.FETCH:
        try {
          yield TaskState(requestState: StateStatus.LOADING);
          final todoTasks = taskServices.getTasks(
              event.date, TaskStatus.TODO, event.categoryId);
          final doingTasks = taskServices.getTasks(
              event.date, TaskStatus.DOING, event.categoryId);
          final doneTasks = taskServices.getTasks(
              event.date, TaskStatus.DONE, event.categoryId);
          final undoneTasks = taskServices.getTasks(
              event.date, TaskStatus.UNDONE, event.categoryId);
          yield TaskState(
              requestState: StateStatus.LOADED,
              todoTasks: todoTasks,
              doingTasks: doingTasks,
              doneTasks: doneTasks,
              undoneTasks: undoneTasks);
        } catch (e) {
          print(' $e');
          yield TaskState(requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESET:
        yield TaskState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
