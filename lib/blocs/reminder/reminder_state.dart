import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';

class ReminderState {
  StateStatus requestSatus;
  List<Task>? tasks;
  String? errormessage;
  ReminderState({required this.requestSatus, this.tasks, this.errormessage});
}
