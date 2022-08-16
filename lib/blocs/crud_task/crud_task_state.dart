import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/task_model.dart';

class CrudTaskState {
  StateStatus requestState;
  Task? task;
  String? errormessage;
  CrudTaskState({required this.requestState, this.task, this.errormessage});
}
