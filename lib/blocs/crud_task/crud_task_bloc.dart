import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/crud_task/crud_task_event.dart';
import 'package:microtask/blocs/crud_task/crud_task_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/task_services.dart';

class CrudTaskBloc extends Bloc<CrudTaskEvent, CrudTaskState> {
  CrudTaskBloc() : super(CrudTaskState(requestState: StateStatus.NONE));
  TaskServices get taskServices => GetIt.I<TaskServices>();

  @override
  Stream<CrudTaskState> mapEventToState(CrudTaskEvent event) async* {
    switch (event.requestEvent) {
      case CrudEventStatus.ADD:
        try {
          yield CrudTaskState(requestState: StateStatus.LOADING);
          final result = taskServices.createTaskService(event.task!);
          yield CrudTaskState(requestState: StateStatus.LOADED);
        } catch (e) {
          print('Error   $e');
          yield CrudTaskState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.EDIT:
        try {
          yield CrudTaskState(requestState: StateStatus.LOADING);
          final result = taskServices.updateTaskService(event.task!);
          yield CrudTaskState(requestState: StateStatus.LOADED);
        } catch (e) {
          print("Error $e");
          yield CrudTaskState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.DELETE:
        try {
          yield CrudTaskState(requestState: StateStatus.LOADING);
          taskServices.deleteTaskService(event.taskId!);
          yield CrudTaskState(requestState: StateStatus.NONE);
        } catch (e) {
          yield CrudTaskState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESETREMINDER:
        try {
          yield CrudTaskState(requestState: StateStatus.LOADING);
          taskServices.resetNotification();
          yield CrudTaskState(requestState: StateStatus.NONE);
        } catch (e) {
          print('switch $e');

          yield CrudTaskState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESET:
        yield CrudTaskState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
