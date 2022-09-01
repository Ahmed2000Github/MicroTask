import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:microtask/services/note_services.dart';
import 'package:microtask/services/task_services.dart';

class TaskCubit extends Cubit<Task> {
  TaskCubit() : super(Task());
  TaskServices get taskServices => GetIt.I<TaskServices>();

  changeState(String taskId) {
    final result = taskServices.getTaskById(taskId);
    emit(result);
  }
}
