import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';

class TaskState {
  StateStatus requestState;
  List<Task>? todoTasks;
  List<Task>? doingTasks;
  List<Task>? doneTasks;
  List<Task>? undoneTasks;
  String? errormessage;
  TaskState(
      {required this.requestState,
      this.todoTasks,
      this.doingTasks,
      this.doneTasks,
      this.undoneTasks,
      this.errormessage});
}
